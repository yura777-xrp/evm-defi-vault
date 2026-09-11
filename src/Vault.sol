pragma solidity ^0.8.20;

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract Vault {
    IERC20 public asset;
    mapping(address => uint256) public shares;
    uint256 public totalShares;

    constructor(address _asset) {
        asset = IERC20(_asset);
    }

    function deposit(uint256 amount) external returns (uint256) {
        require(amount > 0, "amount=0");
        require(asset.transferFrom(msg.sender, address(this), amount), "transfer failed");

        uint256 currentAssets = asset.balanceOf(address(this)) - amount;
        uint256 mintedShares;

        if (totalShares == 0 || currentAssets == 0) {
            mintedShares = amount;
        } else {
            mintedShares = amount * totalShares / currentAssets;
        }

        shares[msg.sender] += mintedShares;
        totalShares += mintedShares;

        return mintedShares;
    }

    function withdraw(uint256 shareAmount) external returns (uint256) {
        require(shareAmount > 0, "shares=0");
        require(shares[msg.sender] >= shareAmount, "insufficient shares");

        uint256 assets = shareAmount * asset.balanceOf(address(this)) / totalShares;

        shares[msg.sender] -= shareAmount;
        totalShares -= shareAmount;

        require(asset.transfer(msg.sender, assets), "transfer failed");

        return assets;
    }
}
