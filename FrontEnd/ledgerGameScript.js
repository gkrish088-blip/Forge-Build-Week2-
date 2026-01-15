import { ethers } from "https://cdnjs.cloudflare.com/ajax/libs/ethers/6.7.0/ethers.min.js";
console.log(ethers.getDefaultProvider());

let signer = null;
let provider;
const connect_button = document.querySelector("#connectBtn");
let metaMaskConected = false;
const connect_status = document.querySelector("#wallet");
let readgameContract;
let writegameContract;
let readtokenContract;
let writetokenContract;
let address;
const balanceFeild = document.querySelector("#balance");
let Person;
let playerExists = false;
let name;
let cows;
let sheeps;
let wolfs;
let horses;
let fishes;
const cowsOwned = document.querySelector("#cowCount");
const sheepsOwned = document.querySelector("#sheepCount");
const wolfOwned = document.querySelector("#wolfCount");
const horsesOwned = document.querySelector("#horseCount");
const fishesOwned = document.querySelector("#fishCount");
let coinsApproved = 0;
const buyCowBtn = document.querySelector("#buyCow");
const sellCowBtn = document.querySelector("#sellCow");
const buySheepBtn = document.querySelector("#buySheep");
const sellSheepBtn = document.querySelector("#sellSheep");
const buyWolfBtn = document.querySelector("#buyWolf");
const sellWolfBtn = document.querySelector("#sellWolf");
const buyHorseBtn = document.querySelector("#buyHorse");
const sellHorseBtn = document.querySelector("#sellHorse");
const buyFishBtn = document.querySelector("#buyFish");
const sellFishBtn = document.querySelector("#sellFish");
let approvedBalance = 0;
let accountBalance = 0;
const approveForm = document.querySelector(".approve-form");

const gamecontractAddress = "0x827ccd2E078361db09c61056d42F6db76e92d426";
const tokencontractAddress = "0x8B9EF4b21F36DF4a3cc2D3384E61C36ddF3b7266";

const gameabi = [
  "function addressToPerson(address) view returns (string,uint256,uint256,uint256,uint256,uint256,bool)",
  "event personCreated(string indexed name,address indexed adrs,uint256 initialCoins)",
  "event Buy(string indexed name,address indexed adrs,string animal,uint256 coinsSpent)",
  "event Sell(string indexed name,address indexed adrs,string animal,uint256 coinsReceived)",
  "function createNewPerson(string)",
  "function buyCow()",
  "function buySheep()",
  "function buyHorse()",
  "function buyWolf()",
  "function buyFish()",
  "function sellCow()",
  "function sellSheep()",
  "function sellFish()",
  "function sellWolf()",
  "function sellHorse()",
];
const tokenabi = [
  "function balanceOf(address user) view returns (uint256)",
  "function approve(address spender, uint256 value)  returns (bool)",
  "function allowance(address owner, address spender) view  returns (uint256)",
];

connect_button.addEventListener("click", async function connectWallet() {
  try {
    if (window.ethereum == null) {
      alert("MetaMask not installed; using read-only defaults");
      provider = ethers.getDefaultProvider();
    } else {
      provider = new ethers.BrowserProvider(window.ethereum);
      metaMaskConected = true;

      connect_button.innerText = "Connected";
      signer = await provider.getSigner();
      address = await signer.getAddress();
      connect_status.innerText = `Acc: ${address}`;
      readgameContract = new ethers.Contract(
        gamecontractAddress,
        gameabi,
        provider
      );
      writegameContract = new ethers.Contract(
        gamecontractAddress,
        gameabi,
        signer
      );
      readtokenContract = new ethers.Contract(
        tokencontractAddress,
        tokenabi,
        provider
      );
      writetokenContract = new ethers.Contract(
        tokencontractAddress,
        tokenabi,
        signer
      );
      console.log("Got signer: " + address);

      Person = await readgameContract.addressToPerson(address);
      playerExists = Person[6];
      PlayerCheck();
    }
  } catch (err) {
    console.error(err);
    alert(`Transaction failed with the error: ${err}`);
  }
});

async function refreshpage() {
  const newPerson = await readgameContract.addressToPerson(address);
  const newname = newPerson[0];
  const newcows = Number(newPerson[1]);
  const newsheeps = Number(newPerson[2]);
  const newwolfs = Number(newPerson[3]);
  const newhorses = Number(newPerson[4]);
  const newfishes = Number(newPerson[5]);
  cowsOwned.innerText = newcows;
  sheepsOwned.innerText = newsheeps;
  wolfOwned.innerText = newwolfs;
  fishesOwned.innerText = newfishes;
  horsesOwned.innerText = newhorses;
  approvedBalance = await readtokenContract.allowance(
    address,
    gamecontractAddress
  );
  accountBalance = await readtokenContract.balanceOf(address);
  balanceFeild.innerHTML = `<p> Acc Bal : ${accountBalance} <br> Spendables : ${approvedBalance}`;
  console.log("refreshed");
}
async function PlayerCheck() {
  if (metaMaskConected == true) {
    try {
      if (playerExists) {
        refreshpage();
      } else {
        const tx = await writegameContract.createNewPerson("New Person");
        await tx.wait();
        approve(100);
        refreshpage();
      }
    } catch (err) {
      console.error(err);
      alert(`Transaction failed with the error: ${err}`);
    }
  }
}

async function approve(n) {
  const bal = await readtokenContract.balanceOf(address);
  if (Number(bal) >= n) {
    const tx = await writetokenContract.approve(gamecontractAddress, n);
    await tx.wait();
    refreshpage();
    console.log(
      await readtokenContract.allowance(address, gamecontractAddress)
    );
  } else {
    alert("You dont have enough balance");
  }
}
buyCowBtn.addEventListener("click", async function () {
  if (approvedBalance >= 20) {
    const tx = await writegameContract.buyCow();
    await tx.wait();
    refreshpage();
  } else {
    alert("You dont have enough coins");
  }
});
buySheepBtn.addEventListener("click", async function () {
  if (approvedBalance >= 15) {
    const tx = await writegameContract.buySheep();
    await tx.wait();
    refreshpage();
  } else {
    alert("You dont have enough coins");
  }
});
buyWolfBtn.addEventListener("click", async function () {
  if (approvedBalance >= 50) {
    const tx = await writegameContract.buyWolf();
    await tx.wait();
    refreshpage();
  } else {
    alert("You dont have enough coins");
  }
});
buyHorseBtn.addEventListener("click", async function () {
  if (approvedBalance >= 40) {
    const tx = await writegameContract.buyHorse();
    await tx.wait();
    refreshpage();
  } else {
    alert("You dont have enough coins");
  }
});
buyFishBtn.addEventListener("click", async function () {
  if (approvedBalance >= 10) {
    const tx = await writegameContract.buyFish();
    await tx.wait();
    refreshpage();
  } else {
    alert("You dont have enough coins");
  }
});
sellCowBtn.addEventListener("click", async () => {
  const p = await readgameContract.addressToPerson(address);
  const ownedCow = Number(p[1]);
  if (ownedCow > 0) {
    const tx = await writegameContract.sellCow();
    await tx.wait();
    refreshpage();
  } else {
    alert("You dont have enough cows");
  }
});
sellHorseBtn.addEventListener("click", async function () {
  const p = await readgameContract.addressToPerson(address);
  const ownedHorse = Number(p[4]);
  if (ownedHorse > 0) {
    const tx = await writegameContract.sellHorse();
    await tx.wait();
    refreshpage();
  } else {
    alert("You dont have enough horses");
  }
});
sellSheepBtn.addEventListener("click", async function () {
  const p = await readgameContract.addressToPerson(address);
  const ownedSheep = Number(p[2]);
  if (ownedSheep > 0) {
    const tx = await writegameContract.sellSheep();
    await tx.wait();
    refreshpage();
  } else {
    alert("You dont have enough Sheeps");
  }
});
sellWolfBtn.addEventListener("click", async function () {
  const p = await readgameContract.addressToPerson(address);
  const ownedwolf = Number(p[3]);
  if (ownedwolf > 0) {
    const tx = await writegameContract.sellWolf();
    await tx.wait();
    refreshpage();
  } else {
    alert("You dont have enough Wolves");
  }
});
sellFishBtn.addEventListener("click", async function () {
  const p = await readgameContract.addressToPerson(address);
  const ownedFish = Number(p[5]);
  console.log(ownedFish);
  if (ownedFish > 0) {
    const tx = await writegameContract.sellFish();
    await tx.wait();
    refreshpage();
  } else {
    alert("You dont have enough Fishes");
  }
});
approveForm.addEventListener("submit", async function (e) {
  if (metaMaskConected == true) {
    e.preventDefault();
    const input = document.querySelector("#approveValue");
    const val = Number(input.value);

    if (isNaN(val) || val <= 0) {
      alert("Enter a valid amount");
      return;
    } else {
      approve(val);
      input.value ="";
    }
  } else {
    alert("Metamask not Connected");
  }
});
