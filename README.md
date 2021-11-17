Publisher (on behalf of artists): NFT content author/owner. They will share revenues and royalties with artists offline.
CP (Crypto Poetry) - this is us: We help the Publisher to mint NFTs and facilitate their sale in our marketplace (store). We share the initial revnue and future royalties.
Creators: Publisher + CP (Only two in first version)
Buyer: The party that purchases NFTs and actually pays the price for it


1. Publisher Onboarding
- CP emgages publishers offline and invite them to sign-up
- Publisher registers in the traditional sense with email and password
- Publisher creates a collection
- Publisher add poems to collection. I assume that they will add a cover image and lyrics. The lyrics is an html file so can come with background image. What about voice overs? do we want to have a designer that helps with the creation of the html?
- Publisher assigns attributes and finalzies the number of copies for each poem
- CP reviews collection and approves or make updates with agreement of Publisher (manual process?)
- The status of the collection is "Draft" until they approve it for minting. 
- The json files for minting is ready in DB

2. Minting
- Publisher front end connects to the publisher's wallet
- Publisher selects a collection to mint
- CP processes metadata upload (either with publisher's key or store key). NOTE: Uploaded metadata can be partially edited by owner
- Validate metadata and mark for review
- Publisher validates data and mark for minting (NOTE: created NFT cannot be modified in any way so additional check is not redundant)
- Publisher opens validated record, connects wallet and initialize candy machine for minting. Json data is supplied with agreed seller_fee_basis_points and creators records including store owners
- Publisher mints tokens which appears in creator's wallet
- Store owners (listed in creators records) sign the NFT - each one (In first version - only one Publisher). 
- NFT is ready for sale.

3. Pusblishing for sale:
- So the NFT is minted to the Publisher's wallet with their payment. 
- At this point the only cost incurred is data upload and minting cost. 
- All creators are validated and token is ready for sale. 
- Single candy machine can prepate minting of a set of NFT and multiple records can be created
- Publisher connects wallet and create auction for simple NFT sale. 
- Token is removed from Publisher's wallet and wrapped into auction contract for sale at some price, starting at some date

4. Marketplace flow
- Search DB for auction records, validate auction status with blockchain and list NFT available for sale
- Buyer connects wallet and choose NFT for purchase
- Buyer clicks 'Buy' and funds are withdrawn from Buyer's account and wrapped. At this point (seems) the purchase can be reverted by seller (YS: I don't think that seller can reverse - the auction has full control and the sale is final)
- Buyer claims the purchase and NFS appears in Buyer's wallet.

5. Accounting flow
- Auction owner settle outstanding purchase and Buyer receives purchase price less seller_fee_basis_points in percent
- seller_fee_basis_points amount is shared between addresses listed as creators in the json according to the pre-defined shares
- All parties can visit their wallets and unwrap SOL to release funds to the wallets

NOTEs: After first step Artist has NFT in the wallet and potentially can do anything - list it for sale at different marketplace, keep it, send it anywhere etc.
The store can receive any commision only if NFT is sold using Metaplex auction contract. It is honoring seller_fee_basis_points and revenue sharing as defined in JSON. Some other sale methods or programs may ignore settings and our system will become just minting platform. (YS: theoritically this is correct but practically, they will do everything through us. They won't have the knowledge or the will to go independently. The whole idea is that we bring the buyers!)

We can link the process to CP's (store owner's) account and mint tokens to store wallet, then create sale auction and collect sale revenue to store treasury. This way Publisher will have no controll and may be forced to sell in our marketplace BUT this violates the whole idea of blockchain contract and requires trust relations between Publisher and CP.
(YS: I agree - I don't think that we should do it. If this really happens, we should charge a setup fee that is waived once the NFTS are listed on our our marketplace). 
