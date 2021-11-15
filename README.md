NOTE: Dockerfile and image tags refer Solana version - currently 1.7.14. It may be needed to change it if command `solana cluster-version` return different value.

1) Build docker image using localtest/Dockerfile
- `cd localtest`
- `docker build -t localtest:v1.7.14 ./`

The image contains solana tools, compiled metaplex binary and nodejs engine with the set of tools. Also Solata tools are linked to devnet and have generated keypair (wallet).

2) Start solana/candy-machine container
- `docker run -ti --rm -p 3000:3000 localtest:v1.7.14`

3) Open Phantom wallet and crete/add wallets:
- Treasury
- Creator
- Mint
- Solana (this one is added via private key and reffer to the solana identity used witin the container)

To import wallet within container run `cat ~/.config/solana/id.json` and copy JSON array to appropriate field in Phantom.

4) Add SOL to Treasury and Solana wallets:
- `solana airdrop 1` (Solana wallet, used during metadata upload to pay for resources hosting)
- `solana airdrop 1 <mint address>` (used during minting)

While airdropping check corresponding wallets to validate wallets.

5) Inside the container create `/test-data/assets` folder and put there two files `0.png` image and `0.json` metadata file:

```
{
    "name": "png0",
    "symbol": "INL0",
    "description": "testing dreamland",
    "seller_fee_basis_points": 5,
    "image": "image.png",
    "external_url": "google.com",
    "collection": {
        "name": "CPoetry Test",
        "family": "CPoetry"
    },
    "properties": {
        "files": [
            {
                "uri": "image.png",
                "type": "image/png"
            }
        ],
        "category": "image/png",
        "creators": [
            {
                "address": "<creator wallet adress>",
                "share": 100
            }
        ]
    }
}
```

6) Run command `metaplex upload ./assets --keypair ~/.config/solana/id.json`
- note <candy-machine ID>
- note <solana ID>
7) set minting start date `metaplex update_candy_machine --date now --keypair ~/.config/solana/id.json`
8) clone minting site `git clone https://github.com/exiled-apes/candy-machine-mint`, `cd candy-machine-mint`
9) run `date +%s` and note timestamp
10) Create environment `nano .env` with content:

```
REACT_APP_CANDY_MACHINE_CONFIG=<solana ID>
REACT_APP_CANDY_MACHINE_ID=<candy-machine ID>
REACT_APP_TREASURY_ADDRESS=<treasury ID>
REACT_APP_CANDY_START_DATE=<timestamp>

REACT_APP_SOLANA_NETWORK=devnet
REACT_APP_SOLANA_RPC_HOST=https://explorer-api.devnet.solana.com
```
11) Run the minting site:
- `yarn install`
- `yarn build`
- `npm start`

12) In the browser open site `http://localhost:3000/` and connect to Mint wallet
