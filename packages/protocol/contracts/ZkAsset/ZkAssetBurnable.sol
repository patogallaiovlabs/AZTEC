

pragma solidity >=0.5.0 <0.6.0;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

import "./ZkAsset.sol";
import "../ACE/ACE.sol";
import "../libs/LibEIP712.sol";
import "../libs/ProofUtils.sol";

contract ZkAssetBurnable is ZkAsset {
    event UpdateTotalBurned(bytes32 noteHash, bytes noteData);
    
    address public owner;

    constructor(
        address _aceAddress,
        address _linkedTokenAddress,
        uint256 _scalingFactor,
        bool _canMintAndBurn,
        bool _canConvert
    ) public ZkAsset(
        _aceAddress,
        _linkedTokenAddress,
        _scalingFactor,
        _canMintAndBurn,
        _canConvert
    ) {
    }

    function confidentialBurn(uint24 _proof, bytes calldata _proofData) external {
        require(_proofData.length != 0, "proof invalid");

        (bytes memory newTotalBurned, 
        bytes memory burnedNotes) = ace.burn(_proof, _proofData, address(this));

        (,
        bytes32 noteHash,
        bytes memory metadata) = newTotalBurned.extractNote();

        logOutputNotes(burnedNotes);
        emit UpdateTotalBurned(noteHash, metadata);
    }
}


