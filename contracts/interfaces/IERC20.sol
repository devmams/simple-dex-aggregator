//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;

interface IERC20 {
    function balanceOf(address owner) external view returns (uint);
    function approve(address spender, uint value) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
