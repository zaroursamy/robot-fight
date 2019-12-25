module.exports = {
  networks: {
     development: {
      host: "127.0.0.1",     // IP du point d'entrée dans le réseau de la blockchain
      port: 7545,            // port sur lequel le réseau de la blockchain communique
      network_id: "1",       // identifiant du réseau de blockchain (un noeud peut faire tourner plusieurs blockchain)
      from: "0x2AEC32042De9F688B43C35377D3b8C1f5432ADc2", // adresse du détenteur du smart contract (adresse sur le réseau Ethereum ou de son compte/portefeuille)
     },
  },

  // Set default mocha options here, use special reporters etc.
  mocha: {
  },

  // Configure your compilers
  compilers: {
    solc: {
    }
  }
}
