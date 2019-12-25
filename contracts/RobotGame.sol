pragma solidity ^0.5.0;


contract RobotGame {

  Robot[] public robots; // public: visible en dehors du smartcontract

  mapping(address => uint) public userToRobot; // mapping entre l'utilisateur et l'id du robot. non signé: entier >=0
  mapping(address => int) bank; // mapping entre l'utilisateur et son compte entier signé: négatif ou positif

  // Settings
  address owner; // adresse du détenteur du smartcontract
  uint8 starterAccount = 250; // montant du compte d'un nouveau joueur
  uint8 bet = 50; // montant d'un pari
  uint8 nameCost = 10; // montant que l'on paie pour changer de nom de robot
  uint8 beginnerExp = 10; // expérience d'un robot venant d'être livré


  modifier onlyOwner {
    require(owner == msg.sender, "This is not the owner");
    _;
  }

  // modifie le compte de départ
  function updateStarterAccount(uint8 _newStarterAccount) external onlyOwner {
    starterAccount = _newStarterAccount;
  }

  // modifie le montant des mises
  function updateBet(uint8 _newBet) external onlyOwner {
    bet = _newBet;
  }

  // modifie l'xp de départ d'un robot
  function updateBeginnerExp(uint8 _newBeginnerExp) external onlyOwner {
    beginnerExp = _newBeginnerExp;
  }

  // modifie le cout de changement du nom de robot
  function updateNameCost(uint8 _newNameCost) external onlyOwner {
    nameCost = _newNameCost;
  }

  // modifie le proprietaire du smart contract
  function updateOwner(address _newOwner) external onlyOwner {
    owner = _newOwner;
  }

  // permet de savoir si un user a un robot dans le jeu
  // l'ID d'un robot commence >=1: 0 signifie jms réinitialisé
  function _haveAccount(address _user) internal view returns (bool) {
    return userToRobot[_user] > 0;
  }

  modifier requireAccount {
    require(_haveAccount(msg.sender), "Le sender n'a pas de compte");
    _;
  }

  // savoir combien le joueur a en banque
  function balance() external view requireAccount returns (int){
    return bank[msg.sender];
  }

  // modifie le nom d'un robot
  function changeRobotName(string calldata _newName) external requireAccount{
    require(bank[msg.sender]>nameCost, "Pas assez d'argent pour changer de nom");

    uint robotId = userToRobot[msg.sender];
    Robot storage hisRobot = robots[robotId-1];

    require(keccak256(abi.encode(hisRobot.name)) != keccak256(abi.encode(_newName)), "Le nouveau nom est le même que l'ancien");
    hisRobot.name = _newName;
    bank[msg.sender] -= nameCost;
  }

  // creer un nouveau robot avec son compte en banque
  function createRobot() external {
    require(!_haveAccount(msg.sender), "L'user a déjà un compte");

    uint id = robots.push(Robot("NewBot", beginnerExp, msg.sender));

    userToRobot[msg.sender] = id;

    bank[msg.sender] = int(starterAccount);
  }


  struct Robot {
    string name;
    uint exp;
    address user; // maitre du robot
  }

  // fonction executée lorsque le smart contract est déployé
  constructor() public {
    owner = msg.sender; // msg: variable injectée par Ethereum. sender: adresse du compte qui appelle la méthode
  }

}
