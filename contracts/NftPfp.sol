// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "hardhat/console.sol";

contract NftPfp {
    // tokenId -> genome
    mapping(uint256 => uint256) packedFourGenomes;

    function saveFourGenome(uint256 _packedFourGenome, uint256 index) external {
        packedFourGenomes[index] = _packedFourGenome;
    }

    function saveBatchFourGenomes(
        uint256[] calldata _packedFourGenomes
    ) external {
        for (uint256 index; index != _packedFourGenomes.length; ++index) {
            packedFourGenomes[index] = _packedFourGenomes[index];
        }
    }

    function saveGenomes(uint256[] calldata _gnomeInputs) external {
        for (uint256 index; index != _gnomeInputs.length; ++ index) {
            packedFourGenomes[index] = _gnomeInputs[index];
        }
    }

    function getPackedGenome(
        uint256 id
    ) public view returns (uint64 packedGenome) {
        uint256 packedFourGenome = packedFourGenomes[id / 4];
        packedGenome = uint64((packedFourGenome << ((id % 4) * 64)) >> 192);
        // console.log("packedGenome : ");
        // console.log(packedGenome);
        // console.log("packedFourGenome : ");
        // console.log(packedFourGenome);
    }

    function packToFourGenome(
        uint64[] calldata packedGenomes
    ) external pure returns (uint256 packedFourGenome) {
        require(packedGenomes.length == 4, "Invalid packedGenomes length");
        packedFourGenome =
            (uint256(packedGenomes[0]) << 192) |
            (uint256(packedGenomes[1]) << 128) |
            (uint256(packedGenomes[2]) << 64) |
            uint256(packedGenomes[3]);
        // console.log("packedFourGenome : ");
        // console.log(packedFourGenome);
    }

    function unpackFromFourGenome(
        uint256 packedFourGenome
    ) external pure returns (uint64[] memory packedGenomes) {
        packedGenomes = new uint64[](4);
        packedGenomes[3] = uint64(packedFourGenome & 0xFFFFFFFFFFFFFFFF);
        packedFourGenome = packedFourGenome >> 64;
        packedGenomes[2] = uint64(packedFourGenome & 0xFFFFFFFFFFFFFFFF);
        packedFourGenome = packedFourGenome >> 64;
        packedGenomes[1] = uint64(packedFourGenome & 0xFFFFFFFFFFFFFFFF);
        packedFourGenome = packedFourGenome >> 64;
        packedGenomes[0] = uint64(packedFourGenome);
    }

    function packGenome(
        uint64[] calldata _genome
    ) public pure returns (uint64 packedGenome) {
        require(_genome.length == 12, "Invalid genome length");

        packedGenome =
            (_genome[0] << 58) |
            (_genome[1] << 53) |
            (_genome[2] << 49) |
            // size of (_genome[4], _genome[3]) = 10 but reduce it to 9
            ((_genome[3] * 11 + _genome[4]) << 40) |
            (_genome[5] << 33) |
            (_genome[6] << 27) |
            (_genome[7] << 21) |
            (_genome[8] << 14) |
            (_genome[9] << 10) |
            (_genome[10] << 5) |
            _genome[11];
    }

    function unpackGenome(
        uint64 packedGenome
    ) public pure returns (uint8[] memory) {
        uint8[] memory _genome = new uint8[](12);

        _genome[11] = uint8(packedGenome & 0x1F);
        packedGenome = packedGenome >> 5;
        _genome[10] = uint8(packedGenome & 0x1F);
        packedGenome = packedGenome >> 5;
        _genome[9] = uint8(packedGenome & 0x0F);
        packedGenome = packedGenome >> 4;
        _genome[8] = uint8(packedGenome & 0x7F);
        packedGenome = packedGenome >> 7;
        _genome[7] = uint8(packedGenome & 0x3F);
        packedGenome = packedGenome >> 6;
        _genome[6] = uint8(packedGenome & 0x3F);
        packedGenome = packedGenome >> 6;
        _genome[5] = uint8(packedGenome & 0x7F);
        packedGenome = packedGenome >> 7;

        // size of (_genome[4], _genome[3]) = 10 but reduce it to 9
        _genome[4] = uint8((packedGenome & 0x1FF) % 11);
        _genome[3] = uint8((packedGenome & 0x1FF) / 11);
        packedGenome = packedGenome >> 9;

        _genome[2] = uint8(packedGenome & 0x0F);
        packedGenome = packedGenome >> 4;
        _genome[1] = uint8(packedGenome & 0x1F);
        packedGenome = packedGenome >> 5;
        _genome[0] = uint8(packedGenome & 0x3F);

        return _genome;
    }
}
