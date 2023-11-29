Let's consider an NFT pfp project.

We have the following attributes for our NFTs, with the following ranges of possible values :

- **BackgroundColor** : 0 -> 60
- **BackgroundEffect** : 0 -> 30
- **Wings** : 0 -> 10
- **SkinColor** : 0 -> 40
- **SkinPattern** : 0 -> 10
- **Body** : 0 -> 100
- **Mouth** : 0 -> 50
- **Eyes** : 0 -> 60
- **Hat** : 0 -> 100
- **Pet** : 0 -> 10
- **Accessory** : 0 -> 25
- **Border** : 0 -> 30

Problem :

- We have 5000 NFTs, each have the attributes above randomized.
- We want to deploy on mainnet, and we are at peak usage (4k USD ETH, gas cost at 500 gwei).
- The deployer will need to store all of the 5000 genomes on-chain, before the sale can go live.
- Those genomes need to be packed in the most optimal way to reduce gas usage as much as possible, to be able to minimize deployment costs.
- We need to have a contract function to be able to decode a packed genome, and retrieve the attributes value, in order to be able to implement an on-chain game making use of those attributes. This function will also need to be gas optimized.


Tasks :
1. Figure out the most optimized way of storing 5k genomes on chain, while reducing gas costs
2. Implement a function to decode a genome, and return genome attributes
3. Describe your thought process along the way of solving this problem