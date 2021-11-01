#!/bin/bash
set -e -m

solana config set --url http://localhost:8899

exec solana-test-validator \
  --bpf-program p1exdMJcjVao65QdewkaZRUnU6VPSXhus9n2GzWfh98 /tmp/deploy/metaplex.so \
  --bpf-program faircnAB9k59Y4TXmLabBULeuTLgV7TkGMGNkjnA15j /tmp/deploy/fair_launch.so \
  --bpf-program auctxRXPeJoc4817jDhf4HbjnhEcr1cCXenosMhK5R8 /tmp/deploy/metaplex_auction.so \
  --bpf-program metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s /tmp/deploy/metaplex_token_metadata.so \
  --bpf-program vau1zxA2LbssAUEF7Gpw91zMM1LvXrvpzJtmZ58rPsn /tmp/deploy/metaplex_token_vault.so \
  --bpf-program cndyAnrLdpjq1Ssp1z8xxDsB8dxe7u4HL5Nxi2K5WXZ /tmp/deploy/nft_candy_machine.so \
  --quiet &
while ! nc -z localhost 8899; do
  sleep 0.1
done

if [ ! -f ~/.config/solana/id.json ]; then
  solana-keygen new --outfile ~/.config/solana/id.json --no-bip39-passphrase
fi
export PUBKEY=$(solana-keygen pubkey ~/.config/solana/id.json)

if [ ! -d /test-data/metaplex ]; then
  cd /test-data && git clone https://github.com/metaplex-foundation/metaplex
  echo "REACT_APP_STORE_OWNER_ADDRESS_ADDRESS=$PUBKEY" > metaplex/js/packages/web/.env
  echo "REACT_APP_STORE_ADDRESS=http://localhost:3000/" >> metaplex/js/packages/web/.env
  cd metaplex && patch -p1 < /tmp/patch.diff
  cd js && yarn install && yarn bootstrap
fi

cd /test-data/metaplex/js
exec yarn start

# solana program deploy /root/metaplex/rust/target/deploy/fair_launch.so --program-id faircnAB9k59Y4TXmLabBULeuTLgV7TkGMGNkjnA15j
# solana program deploy /root/metaplex/rust/target/deploy/nft_candy_machine.so --program-id cndyAnrLdpjq1Ssp1z8xxDsB8dxe7u4HL5Nxi2K5WXZ
# solana program deploy /root/metaplex/rust/target/deploy/spl_auction.so --program-id auctxRXPeJoc4817jDhf4HbjnhEcr1cCXenosMhK5R8
# solana program deploy /root/metaplex/rust/target/deploy/spl_metaplex.so --program-id p1exdMJcjVao65QdewkaZRUnU6VPSXhus9n2GzWfh98
# solana program deploy /root/metaplex/rust/target/deploy/spl_token_metadata.so --program-id metaqbxxUerdq28cj1RbAWkYQm3ybzjb6a8bt518x1s
# solana program deploy /root/metaplex/rust/target/deploy/spl_token_vault.so --program-id vau1zxA2LbssAUEF7Gpw91zMM1LvXrvpzJtmZ58rPsn
