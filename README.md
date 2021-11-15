Artist: NFT content author/owner
Creator: The party which is sharing NFT sale revenue
Buyer: The party which purchase NFT and actually pays the price for it


1. Artist flow
- Artist front end connects to the creator's wallet
- Prepare cover image, content HTML and upload to the DB
- Process metadata upload (either with creator's key or store key). NOTE: Uploaded metadata can be partially edited by owner
- Validate metadata and mark for review
- Store owner validate data and mark for minting (NOTE: created NFT cannot be modified in any way so additional check is not redundant)
- Artist opens validated record, connects wallet and initialize candy machine for minting. Json data is supplied with agreed seller_fee_basis_points and creators records including store owners
- Artist mint token which appears in creator's wallet
- Store owners (listed in creators records) sign the NFT - each one. After this NFT is ready for sale.

So the NFT is minted at Artist's cost and reside in Artist's wallet. At this point the only cost incurred is data upload and minting cost. All creators are validated and token is ready for sale. Single candy machine can prepate minting of a set of NFT and multiple records can be created

- Artist connects wallet and create auction for simple NFT sale. Token is removed from Artist's wallet and wrapped into auction contract for sale at some price, starting at some date

2. Marketplace flow
- Search DB for auction records, validate auction status with blockchain and list NFT available for sale
- Buyer connects wallet and choose NFT for purchase
- Buyer clicks 'Buy' and funds are withdrawn from Buyer's account and wrapped. At this point (seems) the purchase can be reverted by seller
- Buyer claims the purchase and NFS appears in Buyer's wallet.

3. Accounting flow
- Auction owner settle outstanding purchase and Buyer receives purchase price less seller_fee_basis_points in percent
- seller_fee_basis_points amount is shared between addresses listed as creators in the json according to the pre-defined shares
- All parties can visit their wallets and unwrap SOL to release funds to the wallets


NOTEs: After first step Artist has NFT in the wallet and potentially can do anything - list it for sale at different marketplace, keep it, send it anywhere etc.
The store can receive any commision only if NFT is sold using Metaplex auction contract. It is honoring seller_fee_basis_points and revenue sharing as defined in JSON. Some other sale methods or programs may ignore settings and our system will become just monting plaatform.

We can link the process to store owner's account and mint tokens to store wallet, then create sale auction and collect sale revenue to store treasury. This way Artist will have no controll and may be forced to sell in our marketplace BUT this violates the whole idea of blockchain contract and requires trust relations between Artist and Store.
