// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function balanceOf(address user) external view returns (uint256);
}

contract Ledger {
    struct Person {
        string name;
        uint256 cows;
        uint256 sheep;
        uint256 wolfs;
        uint256 horses;
        uint256 fishes;
        bool exists;
    }

    IERC20 public token;

    constructor(address tokenAddress) {
        token = IERC20(tokenAddress);
    }

    mapping(address => Person) public addressToPerson;

    uint256 noOfGlobalCows = 100;
    uint256 noOfGlobalWolfs = 10;
    uint256 noOfGlobalHorses = 30;
    uint256 noOfGlobalSheep = 300;
    uint256 noOfGlobalFishes = 1000;

    event personCreated(
        string indexed name,
        address indexed adrs,
        uint256 initialCoins
    );
    event Buy(
        string indexed name,
        address indexed adrs,
        string animal,
        uint256 coinsSpent
    );
    event Sell(
        string indexed name,
        address indexed adrs,
        string animal,
        uint256 coinsReceived
    );

    function createNewPerson(string memory name) public {
        require(
            addressToPerson[msg.sender].exists == false,
            "Person already exists"
        );
        addressToPerson[msg.sender] = Person(name, 0, 0, 0, 0, 0, true);
        emit personCreated(addressToPerson[msg.sender].name, msg.sender, 100);
    }


    function buyCow() public {
        Person storage person = addressToPerson[msg.sender];
        require(person.exists == true, "Your account does not exist");
        //require(person.balance >= 20, "Not Enough Balance");
        require(
            noOfGlobalCows > 0,
            "There are no more cows left to buy , you can only buy it when someone else sells their cow"
        );
        bool paid = token.transferFrom(msg.sender, address(this), 20);
        require(paid, "Token payment failed");
        person.cows += 1;
        //person.balance = person.balance - 20;
        noOfGlobalCows -= 1;
        emit Buy(person.name, msg.sender, "Cows", 20);
    }

    function buyWolf() public {
        Person storage person = addressToPerson[msg.sender];
        require(person.exists == true, "Your account does not exist");
        //require(person.balance >= 50, "Not Enough Balance");
        require(
            noOfGlobalWolfs > 0,
            "There are no more wolfs left to buy , you can only buy it when someone else sells their wolf"
        );
        bool paid = token.transferFrom(msg.sender, address(this), 50);
        require(paid, "Token payment failed");
        noOfGlobalWolfs -= 1;
        person.wolfs += 1;
        //person.balance = person.balance - 50;
        emit Buy(person.name, msg.sender, "Wolf", 50);
    }

    function buySheep() public {
        Person storage person = addressToPerson[msg.sender];
        require(person.exists == true, "Your account does not exist");
        //require(person.balance >= 15, "Not Enough Balance");
        require(
            noOfGlobalSheep > 0,
            "There are no more sheep left to buy , you can only buy it when someone else sells their sheep"
        );
        bool paid = token.transferFrom(msg.sender, address(this), 15);
        require(paid, "Token payment failed");
        noOfGlobalSheep -= 1;
        person.sheep += 1;
        //person.balance = person.balance - 15;
        emit Buy(person.name, msg.sender, "Sheep", 15);
    }

    function buyHorse() public {
        Person storage person = addressToPerson[msg.sender];
        require(person.exists == true, "Your account does not exist");
        //require(person.balance >= 40, "Not Enough Balance");
        require(
            noOfGlobalHorses > 0,
            "There are no more horses left to buy , you can only buy it when someone else sells their horse"
        );
        bool paid = token.transferFrom(msg.sender, address(this), 40);
        require(paid, "Token payment failed");
        noOfGlobalHorses -= 1;
        person.horses += 1;
        //person.balance = person.balance - 40;
        emit Buy(person.name, msg.sender, "Horse", 40);
    }

    function buyFish() public {
        Person storage person = addressToPerson[msg.sender];
        require(person.exists == true, "Your account does not exist");
        //require(person.balance >= 10, "Not Enough Balance");
        require(
            noOfGlobalFishes > 0,
            "There are no more fish left to buy , you can only buy it when someone else sells their fish"
        );
        bool paid = token.transferFrom(msg.sender, address(this), 10);
        require(paid, "Token payment failed");
        noOfGlobalFishes -= 1;
        person.fishes += 1;
        // person.balance = person.balance - 10;
        emit Buy(person.name, msg.sender, "Fish", 10);
    }

    function sellCow() public {
        Person storage person = addressToPerson[msg.sender];
        require(person.exists == true, "Your account does not exist");
        require(person.cows > 0, "You dont have enough cows to sell");
        bool paid = token.transfer(msg.sender, 20);
        require(paid, "Game Treasure Empty");
        person.cows = person.cows - 1;
        //person.balance += 20;
        noOfGlobalCows += 1;
        emit Sell(person.name, msg.sender, "Cow", 20);
    }

    function sellWolf() public {
        Person storage person = addressToPerson[msg.sender];
        require(person.exists == true, "Your account does not exist");
        require(person.wolfs > 0, "You dont have enough wolfs to sell");
        bool paid = token.transfer(msg.sender, 50);
        require(paid, "Game Treasure Empty");
        person.wolfs = person.wolfs - 1;
        //person.balance += 50;
        noOfGlobalWolfs += 1;
        emit Sell(person.name, msg.sender, "Wolf", 50);
    }

    function sellHorse() public {
        Person storage person = addressToPerson[msg.sender];
        require(person.exists == true, "Your account does not exist");
        require(person.horses > 0, "You dont have enough horses to sell");
        bool paid = token.transfer(msg.sender, 40);
        require(paid, "Game Treasure Empty");
        person.horses = person.horses - 1;
        //person.balance += 40;
        noOfGlobalHorses += 1;
        emit Sell(person.name, msg.sender, "Horse", 40);
    }

    function sellSheep() public {
        Person storage person = addressToPerson[msg.sender];
        require(person.exists == true, "Your account does not exist");
        require(person.sheep > 0, "You dont have enough sheep to sell");
        bool paid = token.transfer(msg.sender, 15);
        require(paid, "Game Treasure Empty");
        person.sheep = person.sheep - 1;
        // person.balance += 15;
        noOfGlobalSheep += 1;
        emit Sell(person.name, msg.sender, "Sheep", 15);
    }

    function sellFish() public {
        Person storage person = addressToPerson[msg.sender];
        require(person.exists == true, "Your account does not exist");
        require(person.fishes > 0, "You dont have enough fishes to sell");
        bool paid = token.transfer(msg.sender, 10);
        require(paid, "Game Treasure Empty");
        person.fishes = person.fishes - 1;
        // person.balance += 10;
        noOfGlobalFishes += 1;
        emit Sell(person.name, msg.sender, "Fish", 10);
    }
}
