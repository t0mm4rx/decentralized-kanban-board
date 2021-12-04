pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
    constructor() public ERC20("Token", "TK") {
        _mint(msg.sender, 1000000 * (10**decimals()));
    }
}
