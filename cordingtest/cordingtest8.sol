// SPDX-License-Identifier: GPL-3.0

pragma solidity >= 0.8.2 < 0.9.0;

contract Test8 {
/*
안건을 올리고 이에 대한 찬성과 반대를 할 수 있는 기능을 구현하세요. 
안건은 번호, 제목, 내용, 제안자(address) 그리고 찬성자 수와 반대자 수로 이루어져 있습니다.(구조체)
안건들을 모아놓은 자료구조도 구현하세요. 

사용자는 자신의 이름과 주소, 자신이 만든 안건 그리고 자신이 투표한 안건과 어떻게 투표했는지(찬/반)에 대한 정보[string => bool]로 이루어져 있습니다.(구조체)

* 사용자 등록 기능 - 사용자를 등록하는 기능
* 투표하는 기능 - 특정 안건에 대하여 투표하는 기능, 안건은 제목으로 검색, 이미 투표한 건에 대해서는 재투표 불가능
* 안건 제안 기능 - 자신이 원하는 안건을 제안하는 기능
* 제안한 안건 확인 기능 - 자신이 제안한 안건에 대한 현재 진행 상황 확인기능 - (번호, 제목, 내용, 찬반 반환 // 밑의 심화 문제 풀었다면 상태도 반환)
* 전체 안건 확인 기능 - 제목으로 안건을 검색하면 번호, 제목, 내용, 제안자, 찬반 수 모두를 반환하는 기능
-------------------------------------------------------------------------------------------------
* 안건 진행 과정 - 투표 진행중, 통과, 기각 상태를 구별하여 알려주고 15개 블록 후에 전체의 70%가 투표에 참여하고 투표자의 66% 이상이 찬성해야 통과로 변경, 둘 중 하나라도 만족못하면 기각
*/
    enum ProposalStatus { Voting, Passed, Rejected }

    struct Proposal {
        uint id; 
        string title; 
        string content; 
        address proposer; 
        uint agreeCount; 
        uint disagreeCount; 
        ProposalStatus status; 
    }

    struct User {
        string name; 
        mapping(uint => bool) votes; 
    }

    Proposal[] proposals;
    mapping(address => User) users; 
    mapping(address => bool) registeredUsers;
    uint totalProposals; 

    modifier onlyRegistered() {
        require(registeredUsers[msg.sender], "User not registered");
        _;
    }

    function registerUser(string memory name) public {
        require(!registeredUsers[msg.sender], "User already registered");
        User storage user = users[msg.sender];
        user.name = name;
        registeredUsers[msg.sender] = true;
    }

    function propose(string memory title, string memory content) public onlyRegistered {
        proposals.push(Proposal({
            id: totalProposals,
            title: title,
            content: content,
            proposer: msg.sender,
            agreeCount: 0,
            disagreeCount: 0,
            status: ProposalStatus.Voting
        }));
        totalProposals++;
    }

    function findProposalByTitle(string memory title) internal view returns (uint) {
        for (uint i = 0; i < totalProposals; i++) {
            if (keccak256(abi.encodePacked(proposals[i].title)) == keccak256(abi.encodePacked(title))) {
                return proposals[i].id;
            }
        }
        revert("Proposal not found");
    }

    function vote(string memory title, bool agree) public onlyRegistered {
        uint proposalId = findProposalByTitle(title);
        User storage user = users[msg.sender];
        require(!user.votes[proposalId], "Already voted on this proposal");

        Proposal storage proposal = proposals[proposalId];
        if (agree) {
            proposal.agreeCount++;
        } else {
            proposal.disagreeCount++;
        }
        user.votes[proposalId] = true;
    }

    function getUserProposals() public view onlyRegistered returns (Proposal[] memory) {
        uint proposalCount = 0;
        for (uint i = 0; i < totalProposals; i++) {
            if (proposals[i].proposer == msg.sender) {
                proposalCount++;
            }
        }

        Proposal[] memory userProposals = new Proposal[](proposalCount);
        uint index = 0;
        for (uint i = 0; i < totalProposals; i++) {
            if (proposals[i].proposer == msg.sender) {
                userProposals[index] = proposals[i];
                index++;
            }
        }
        return userProposals;
    }

    function getProposalByTitle(string memory title) public view returns (
        uint proposalId,
        string memory proposalTitle,
        string memory proposalContent,
        address proposer,
        uint agreeCount,
        uint disagreeCount,
        ProposalStatus status
    ) {
        uint id = findProposalByTitle(title);
        Proposal storage proposal = proposals[id];
        return (
            proposal.id,
            proposal.title,
            proposal.content,
            proposal.proposer,
            proposal.agreeCount,
            proposal.disagreeCount,
            proposal.status
        );
    }

    function getAllProposals() public view returns (Proposal[] memory) {
        return proposals;
    }
}