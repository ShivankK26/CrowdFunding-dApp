// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    struct Campaign {
        address owner; // DataType NameOfVariable
        string title; // We're creating a Structure which stores the details of any particular Campaign.
        string description; // The details of the campaign
        uint256 target; // The target amount required for the campaign.
        uint256 deadline; // Deadline of the campaign.
        uint256 amountCollected; // Total amount collected.
        string image; // We're using string datatype because we'll be using the URL of the image.
        address[] donators; // Creating an array of all the donators by writing address[].
        uint256[] donations; // Creating an array of all the donations which have been made.
    }

    mapping(uint256 => Campaign) public campaigns; // mapping (keyType => valueType) public myMapping. The keys are used to index and retrieve the corresponding values. Mappings are often used to store and retrieve data in a smart contract based on specific identifiers.;

    uint256 public numberOfCampaigns = 0; // Global functions starting from 0 for number of campaigns. Creating a track on number of campaigns in order to give them IDs.



    // Creating functions for performing various actions.

    function createCampaign(address _owner, string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image) public returns(uint256) { // We used underscore because the owner, title, description, etc. parameters are used in the function only. This is a way of calling. Also we used memory because it is a syntax which is used while writing string keyword.
        // returns uint256 is used for returning a number in this case which is the ID.
        // storage keyword is used to specify the location where state variables are stored. State variables are variables defined within a contract that maintain their values across multiple function calls and throughout the lifetime of the contract.
        Campaign storage campaign = campaigns[numberOfCampaigns];

        // Require() statement is used to test if everything is good?
        // require(condition, errorMessage);
        require(_deadline > block.timestamp, "The deadline should be a date in the future."); // block.timestamp variable is often used in smart contracts to incorporate time-based logic or to enforce time-related constraints. It allows contracts to reference the time at which a particular block is mined.

        // If the code is wrong then it won't proceed after the above statement.
        // If everything is okay then we'll fillup our campaign.

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++; // Incrementing the number Of Campaigns.


        return numberOfCampaigns - 1; // Returns the index of newly created campaign.
   
    } 


    function donateToCampaign(uint256 _id) public payable { // payable is used to pay some amount of cryptocurrency.
        uint256 amount = msg.value; // msg.value includes the amount of ether that we're going to send from our frontend in the current transaction.

        Campaign storage campaign = campaigns[_id]; // This is the mapping which we've created on the line 17 this is used for accessing that mapping.

        campaign.donators.push(msg.sender); // We're pushing the address of the person who donated the money
        campaign.donations.push(amount); // We're pushing the entire collected amount.

        // Now we'll make the transactions
        // sent variable helps us to know whether the transaction has been sent or not.
        // campaign.owner means we're sending it to the owner.
        // value field specifies the amount of Ether (in wei) to send with the call. In this case, amount represents the value being transferred. The empty string "" is passed as the parameter to the call.
        // (bool sent) is a tuple declaration that captures the return value of the call. In this case, it captures a boolean value representing the success or failure of the call. If the call is successful, sent will be true; otherwise, it will be false.

        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if (sent){
            campaign.amountCollected += amount; // Incrementing the collected amount
        }
    } 


    function getDonators(uint256 _id) view public returns(address[] memory, uint256[] memory) { // View means it can view the data and is used for returning it. returns keyword is used to specify the return data types of a function. It is used in the function declaration to indicate what values the function will return when called.
        return (campaigns[_id].donators, campaigns[_id].donations); // It will return the value of donators and donations from the campaigns mapping. 
    }


    function getCampaigns() public view returns (Campaign[] memory) {
        // In this syntax, we're creating a new variable called allCampaigns which is a type of array of multiple campaign structures. Basically we're creating an empty array inside which there are multiple empty structures like [{}, {}, {}];
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        // Now we'll loop through all the campaigns and then populate that variable.
        for(uint256 i = 0; i < numberOfCampaigns; i++){
            Campaign storage item = campaigns[i]; // Here we're fetching specifically each and every campaign and storing them in a variable called item.

            allCampaigns[i] = item; // And we're populating it directly to allCampaigns.
        }

        return allCampaigns;
    }



}