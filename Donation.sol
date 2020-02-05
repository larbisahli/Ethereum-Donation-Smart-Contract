pragma solidity >=0.5.0 <0.7.0;

contract Donation {
    // creating a state varaibles

    string public CurrencySymbol = "MAD";

    address public minter;

    address[] public donorsAddresses;

    address[] public doneesAddresses;

    struct benefactor {
        address donee;
        uint256 contribution;
    }

    // mapping  is a collection of key value pairs,
    // similar to objects in javascript.
    mapping(address => benefactor[]) public benefactors;

    // id should be conerted to hex outside solidity
    // id ~ 0x2343 => 2343
    struct beneficiary {
        bytes2 Case_id;
        uint256 donations;
        bool isActive;
    }

    mapping(address => beneficiary[]) public beneficiaries;

    event Sent(address from, address to, uint256 amount);

    // Constructor code is only run when the contract is created

    constructor() public {
        minter = msg.sender;
    }

    // Sends an amount of newly created coins to an
    // address can only be called by the minter

    function donate(
        bytes2 _Case_id,
        address _donee,
        address _donor,
        uint256 _amount
    ) public returns (bool) {
        require(
            msg.sender == minter,
            "This function is available only by minter"
        );
        require(_amount < 1e60, "Overflow Error");

        if (donorNumOfDonations(_donee) == 0) {
            // keeping track of doners
            donorsAddresses.push(_donor);
        }

        if (donorNumOfDonations(_donee) > 0) {
            for (uint256 i = 0; i < beneficiaries[_donee].length; i++) {
                if (beneficiaries[_donee][i].Case_id == _Case_id) {
                    if (beneficiaries[_donee][i].isActive) {
                        beneficiaries[_donee][i].donations += _amount;
                        benefactors[_donor].push(benefactor(_donee, _amount));

                        // success
                        return true;
                    } else {
                        // means the case is not active.
                        return false;
                    }

                }
            }

            // add a new donation struct into the beneficiary array
            beneficiaries[_donee].push(beneficiary(_Case_id, _amount, true));
            benefactors[_donor].push(benefactor(_donee, _amount));

            // success
            return true;
        } else {
            // keeping track of donees
            doneesAddresses.push(_donee);

            beneficiaries[_donee].push(beneficiary(_Case_id, _amount, true));
            benefactors[_donor].push(benefactor(_donee, _amount));

            // success
            return true;
        }
    }

    function donorTotalDonations(address _donor) public view returns (uint256) {
        uint256 balance;
        for (uint256 i = 0; i < benefactors[_donor].length; i++) {
            balance += benefactors[_donor][i].contribution;
        }

        return balance;
    }

    function donorNumOfDonations(address _donor) public view returns (uint256) {
        return benefactors[_donor].length;
    }

    function getMyTotalDonations() public view returns (uint256) {
        return donorTotalDonations(msg.sender);
    }

    function getMyNumOfDonations() public view returns (uint256) {
        return donorNumOfDonations(msg.sender);
    }

    // need work
    function isDonor(address _donee, address _donor)
        public
        view
        returns (bool)
    {
        return false;
    }

    function isDonee(address _address) public view returns (bool) {
        return false;
    }

    function isActive(address _address) public view returns (bool) {
        return false;
    }

    function getMyAddress() public view returns (address) {
        return msg.sender;
    }

    function numOfDonors() public view returns (uint256) {
        return donorsAddresses.length;
    }
}
