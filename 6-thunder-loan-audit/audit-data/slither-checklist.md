Summary
 - [reentrancy-benign](#reentrancy-benign) (2 results) (Low)
 - [reentrancy-events](#reentrancy-events) (1 results) (Low)
 - [solc-version](#solc-version) (8 results) (Informational)
## reentrancy-benign
Impact: Low
Confidence: Medium
 - [ ] ID-0
Reentrancy in [ThunderLoan.flashloan(address,IERC20,uint256,bytes)](src/protocol/ThunderLoan.sol#L176-L213):
        External calls:
        - [assetToken.updateExchangeRate(fee)](src/protocol/ThunderLoan.sol#L190)
        - [assetToken.transferUnderlyingTo(receiverAddress,amount)](src/protocol/ThunderLoan.sol#L195)
        - [receiverAddress.functionCall(abi.encodeWithSignature(executeOperation(address,uint256,uint256,address,bytes),address(token),amount,fee,msg.sender,params))](src/protocol/ThunderLoan.sol#L197-L206)
        State variables written after the call(s):
        - [s_currentlyFlashLoaning[token] = false](src/protocol/ThunderLoan.sol#L212)

src/protocol/ThunderLoan.sol#L176-L213


 - [ ] ID-1
Reentrancy in [ThunderLoan.flashloan(address,IERC20,uint256,bytes)](src/protocol/ThunderLoan.sol#L176-L213):
        External calls:
        - [assetToken.updateExchangeRate(fee)](src/protocol/ThunderLoan.sol#L190)
        State variables written after the call(s):
        - [s_currentlyFlashLoaning[token] = true](src/protocol/ThunderLoan.sol#L194)

src/protocol/ThunderLoan.sol#L176-L213


## reentrancy-events
Impact: Low
Confidence: Medium
 - [ ] ID-2
Reentrancy in [ThunderLoan.flashloan(address,IERC20,uint256,bytes)](src/protocol/ThunderLoan.sol#L176-L213):
        External calls:
        - [assetToken.updateExchangeRate(fee)](src/protocol/ThunderLoan.sol#L190)
        Event emitted after the call(s):
        - [FlashLoan(receiverAddress,token,amount,fee,params)](src/protocol/ThunderLoan.sol#L192)

src/protocol/ThunderLoan.sol#L176-L213


## solc-version
Impact: Informational
Confidence: High
 - [ ] ID-3
Pragma version[0.8.20](src/protocol/ThunderLoan.sol#L64) necessitates a version too recent to be trusted. Consider deploying with 0.8.18.

src/protocol/ThunderLoan.sol#L64


 - [ ] ID-4
Pragma version[0.8.20](src/interfaces/IFlashLoanReceiver.sol#L2) necessitates a version too recent to be trusted. Consider deploying with 0.8.18.

src/interfaces/IFlashLoanReceiver.sol#L2


 - [ ] ID-5
Pragma version[0.8.20](src/interfaces/IPoolFactory.sol#L2) necessitates a version too recent to be trusted. Consider deploying with 0.8.18.

src/interfaces/IPoolFactory.sol#L2


 - [ ] ID-6
Pragma version[0.8.20](src/protocol/OracleUpgradeable.sol#L2) necessitates a version too recent to be trusted. Consider deploying with 0.8.18.

src/protocol/OracleUpgradeable.sol#L2


 - [ ] ID-7
solc-0.8.20 is not recommended for deployment

 - [ ] ID-8
Pragma version[0.8.20](src/interfaces/ITSwapPool.sol#L2) necessitates a version too recent to be trusted. Consider deploying with 0.8.18.

src/interfaces/ITSwapPool.sol#L2


 - [ ] ID-9
Pragma version[0.8.20](src/interfaces/IThunderLoan.sol#L2) necessitates a version too recent to be trusted. Consider deploying with 0.8.18.

src/interfaces/IThunderLoan.sol#L2


 - [ ] ID-10
Pragma version[0.8.20](src/protocol/AssetToken.sol#L2) necessitates a version too recent to be trusted. Consider deploying with 0.8.18.

src/protocol/AssetToken.sol#L2