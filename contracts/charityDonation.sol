pragma solidity ^0.8.0;

contract CharityDonation {
    struct Donation {
        address donor;
        uint256 amount;
    }

    mapping(address => uint256) public charityBalances;
    mapping(address => Donation[]) public donationsByCharity;
    uint256 public totalNumberOfDonations;

    event DonationMade(address indexed donor, address indexed charity, uint256 amount);

    function donate(address charity) public payable {
        require(msg.value > 0, "Donation amount must be greater than 0");
        donationsByCharity[charity].push(Donation(msg.sender, msg.value));
        charityBalances[charity] += msg.value;
        totalNumberOfDonations++;
        emit DonationMade(msg.sender, charity, msg.value);
    }

    function getDonations(address charity) public view returns (Donation[] memory) {
        return donationsByCharity[charity];
    }

    function getCharityTotal(address charity) public view returns (uint256) {
        return charityBalances[charity];
    }

    function withdraw(address payable charity) public {
        uint256 amount = charityBalances[charity];
        require(amount > 0, "No funds to withdraw");
        charityBalances[charity] = 0;
        charity.transfer(amount);
    }
}
