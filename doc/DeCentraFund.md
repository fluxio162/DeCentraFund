## Title:
DeCentraFund: On-Chain Crowdfunding Platform

## Short description of functionality:
A permissionless crowdfunding system where creators launch funding campaigns, backers pledge ETH toward a campaign goal by a deadline, and funds are either released to the creator or refunded to backers based solely on on-chain logic.

## Off-chain part / frontend:
- React + Next.js UI  
- Campaign creation form (title, goal, deadline)  
- Pledge widget, progress bar, list of backers  
- Wallet integration (MetaMask / WalletConnect)

## On-chain part / contracts:
- **CampaignFactory**  
  - `createCampaign(uint256 goal, uint256 deadline) → campaignId`  
  - Maintains `campaignCount` and registry mapping `campaignId → address Campaign`
- **Campaign**  
  - `pledge()` payable until `deadline`  
  - `withdraw()` callable by creator if `pledged >= goal` after `deadline`  
  - `refund()` callable by any backer if `pledged < goal` after `deadline`  
  - Emits events: `Pledged`, `GoalReached`, `FundsWithdrawn`, `RefundClaimed`

## Token concept incl. used standards:
- **Native ETH only** (no custom ERC-20 token)

## Ether usage:
- Gas for deploying `CampaignFactory` and each `Campaign`  
- Gas for `pledge()`, `withdraw()`, and `refund()` transactions

## Roles:
- **Creator**: deploys campaign, sets `goal` & `deadline`, calls `withdraw()` on success  
- **Backer**: pledges ETH via `pledge()`, calls `refund()` on failure  
- **Factory**: registry & deployer of new `Campaign` contracts

## Data structures:
```solidity
struct CampaignData {
    address creator;
    uint256 goal;
    uint256 pledged;
    uint256 deadline;
    bool    withdrawn;
}
mapping(uint256 => CampaignData) public campaigns;
mapping(uint256 => mapping(address => uint256)) public pledges;
uint256 public campaignCount;

## Security Considerations
- Reentrancy guard on withdrawals (both creator and backers)
- Check block.timestamp <= deadline for pledges
- Prevent over-pledging beyond goal (optional cap)
- Safe handling of refunds to avoid stuck funds

## Used coding patterns in addition to roles (randomness, commitments, timeouts, deposits or other):
- Timeouts: enforce campaign deadline (deadline timestamp)
- Deposits: ETH pledged held in contract until resolution
- Pull payments: both creator and backers pull funds via withdraw() / refund()