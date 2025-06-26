// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EchoLink is ERC721URIStorage, Ownable {
    uint256 public nextTokenId = 1;

    // Event for a newly stored memory
    event MemoryStored(
        address indexed sender,
        uint256 indexed tokenId,
        string memoryType, // text, audio, image, video, or AI echo
        string uri,
        uint256 timestamp
    );

    // Optional memory metadata
    struct EchoMemory {
        string memoryType;
        string uri;
        uint256 timestamp;
    }

    mapping(uint256 => EchoMemory) private _memories;

    constructor() ERC721("EchoLink Memory", "ECHO") {}

    /// @notice Store a memory and mint it as an NFT
    /// @param memoryType Type of memory (text, image, audio, etc.)
    /// @param uri Link to the off-chain or IPFS-hosted memory
    function storeMemory(string calldata memoryType, string calldata uri) external {
        uint256 tokenId = nextTokenId;
        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);

        _memories[tokenId] = EchoMemory({
            memoryType: memoryType,
            uri: uri,
            timestamp: block.timestamp
        });

        emit MemoryStored(msg.sender, tokenId, memoryType, uri, block.timestamp);
        nextTokenId++;
    }

    /// @notice Retrieve full memory details by tokenId
    function getMemory(uint256 tokenId) external view returns (
        string memory memoryType,
        string memory uri,
        uint256 timestamp
    ) {
        require(_exists(tokenId), "Memory does not exist.");
        EchoMemory memory mem = _memories[tokenId];
        return (mem.memoryType, mem.uri, mem.timestamp);
    }
}