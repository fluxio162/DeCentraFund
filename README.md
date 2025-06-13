# DeCentraFund 🏗️

**DeCentraFund** is a fully decentralized, permissionless crowdfunding platform powered by smart contracts. It enables creators to launch funding campaigns, and backers to pledge ETH directly on-chain. Funds are either released to the creator if the goal is met or refunded to backers - all governed by smart contract logic, with no intermediaries.

---

## 🚀 Features

- Create and manage ETH-based crowdfunding campaigns
- Secure, transparent fund pledging and withdrawal
- Automatic refund mechanism if campaign goal is not met
- On-chain campaign registry via a factory contract
- Clean and responsive React/Next.js frontend
- MetaMask & WalletConnect integration for seamless Web3 access

---

## 🧱 Architecture

### 🖥️ Frontend (Off-chain)
- **Built with:** React + Next.js
- **Main Components:**
  - Campaign creation form
  - Campaign detail view (progress, pledgers, status)
  - Pledge widget with ETH input
  - Wallet connection (MetaMask/WalletConnect)

### 🔗 Smart Contracts (On-chain)
- **CampaignFactory.sol**
  - Deploys new campaigns
  - Tracks all deployed campaigns
- **Campaign.sol**
  - Handles pledging, withdrawal, and refunds
  - Enforces deadline and goal logic
  - Emits key events: `Pledged`, `GoalReached`, `FundsWithdrawn`, `RefundClaimed`

---

## ⚙️ Smart Contract Interfaces

### `CampaignFactory`
```solidity
function createCampaign(uint256 goal, uint256 deadline) external returns (uint256);
mapping(uint256 => address) public campaigns;
```

# How to build
Install dependencies
```bash
forge soldeer install
```
To build and run the tests execute:
```bash
forge build
forge test -vvv
```

