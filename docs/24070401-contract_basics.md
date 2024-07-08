# Contract Basics

- [Contract Basics](#contract-basics)
  - [调用合约](#调用合约)
    - [生成合约变量](#生成合约变量)
    - [call](#call)
    - [delegateCall](#delegatecall)
    - [总结](#总结)
  - [合约的创建与删除](#合约的创建与删除)
    - [创建合约](#创建合约)
      - [create](#create)
      - [create2](#create2)
        - [what is create2](#what-is-create2)
        - [why need create2](#why-need-create2)
        - [how to use create2](#how-to-use-create2)
    - [删除合约](#删除合约)
  - [ABI 编码与解码](#abi-编码与解码)
    - [what is ABI](#what-is-abi)
    - [ABI 编码方法](#abi-编码方法)
    - [ABI 解码方法](#abi-解码方法)
  - [哈希函数](#哈希函数)
    - [keccak256 与 sha3](#keccak256-与-sha3)
  - [try-catch](#try-catch)


## 调用合约

### 生成合约变量

在已知被调用合约的源码(接口)和地址的情况下，可以采取生成合约变量的方式来调用已部署的合约，有以下方式可用用来生成合约变量:

- 传入合约地址: `OtherContract(contractAddr).f(p1)` 或 `OtherContract(contractAddr).f{value: msg.value}(p1)`(调用时发送 eth)
- 传入合约变量: 调用方法定义时声明一个 `OtherContract c` 的参数，在方法体中采用 `c.f(p1);` 来调用
- 创建合约变量: 调用方法中 `OtherContract o = OtherContract(contractAddr); o.f(p1);`

> 总结: `contractName(contractAddr)` 来生成合约变量

具体代码实例详见: [](../example/contracts/ContractBasic.sol)

### call

在不知道合约源码或 `ABI` 的情况下，可以采用 `call` 来调用其他合约，具体方式如下:

- `contractAddr.call(bytecode)`
- - 其中 `bytecode=abi.encodeWithSignature("函数签名", 逗号分隔的参数)`，函数签名: `函数名(逗号分隔的参数类型)`
- - 调用时发送 ETH 及指定 gas: `contractAddr.call{value: x, gas: x}(bytecode)`

### delegateCall

deleteCall 的调用方式如下：

- `contractAddr.delegateCall(bytecode)`
- - `bytecode = abi.encodeWithSignature("函数签名", 逗号分隔的参数)`，函数签名为: `函数名(逗号分隔的参数类型)`

关系 `call` 与 `delegateCall` 的区别详见: [./24061701-delegate_call.md](./24061701-delegate_call.md)

### 总结

| 调用合约的方式 | 适应场景 | 语法 |
| --- | --- | --- |
| 生成合约变量 | 已知合约源码或 ABI | `ContractName(contractAddr)` |
| call | 不知道合约与源码及 ABI | `contractAddr.call(abi.encodeWithSignature("函数名(逗号分隔的参数类型)", 逗号分隔的参数))` |
| delegateCall | 不知道合约与源码及 ABI | `contractAddr.delegateCall(abi.encodeWithSignature("函数名(逗号分隔的参数类型)", 逗号分隔的参数))` |

## 合约的创建与删除

### 创建合约

#### create

在合约中创建新的合约，语法如下:

```solidity
    ContractName x = new ContractName{value: _value}(params);
```

说明: 
- 如果合约是 `payable` 修饰的，则可以在创建合约时传递 value 值

#### create2

##### what is create2
create2 的作用就是能够在合约未部署之前预测合约的地址

##### why need create2
满足在合约未部署之前，需要事先计算出合约地址的场景

合约地址的计算

| 创建合约方法 | 合约地址计算方法 | 说明 |
| --- | --- | --- |
| `create` | `contractAddr = hash(creatorAddr, nonce)` | <li> `creatorAddr`: 部署合约的钱包地址或者是合约地址 <li> `nonce`: 创建者地址的 nonce，由于是可变的，且不能准确预测，所以使用 `create` 方法创建出来的合约地址，是不可预测的 |
| `create2` | `contractAddr = hash("0xFF", creatorAddr, salt, initCode)` | <li> `0xFF`: 常量，用于区分 `create` 方法 <li> `creatorAddr`: 部署合约的钱包或合约地址 <li> `salt`: 一个创建者指定的 `byte32` 的值，目的是用来影响创建合约的地址 <li>  `initcode`: 新合约的初始字节码(合约的 `creation code` 和构造函数的参数) |

##### how to use create2

create2 创建合约语法如下:

```solidity
    ContractName x = new ContractName{salt: _salt, value: _value}(params)
```

说明:
- `salt`: 盐值
- `value`: 如果创建的合约时 `payable` 的，则允许创建时向其转账
- `params`: 新合约构造函数的参数

### 删除合约

## ABI 编码与解码

### what is ABI

`ABI`: application binary interface, 应用程序二进制接口，是与合约交互的标准。其数据也是通过了该类型进行编码，由于编码时只包含了数据，在解码时，要申明返回值的类型

### ABI 编码方法

| 方法名 | 备注  |
| --- | ---  |
| `abi.encode(a, b, c)` | <li> 功能: 将每个参数编码成 32 字节的数据并拼接在一起 <li> 使用场景: 当要与合约进行交互时，就要采用该方法来编码参数 |
| `abi.encodePacked()` | <li> 功能: 将给定参数按其所需最低空间进行编码，功能类似 `abi.encode()`，只不过会省略多余填充的 0 <li> 使用场景: 不需要与合约交互，想节省一些空间，如计算 hash |
| `abi.encideWithSignature()` | <li> 功能: 与 `abi.encode` 功能类似，只不过第一个参数为函数签名(functionName(逗号分隔的参数类型)) <li> 使用场景: 在合约中调用其他合约时使用 |
| `abi.encodeWithSelector()` | <li> 功能: 与 `abi.encodeWithSelector` 类似，只不过第一个参数为函数选择器(bytes4(keccak256(functionName(逗号分隔的参数类型)))) <li> 使用场景: 调用其他合约时使用，其编码结果与 `abi.encideWithSignature()` 完全一致 |

### ABI 解码方法

`abi.decode` 用于解码 `abi.encode` 编码的二进制数据，将它还原成原本的参数，用法如下:

```solidity
function decode(bytes memory data) public pure returns(uint dx, address daddr, string memory dname, uint[2] memory darray) {
    (dx, daddr, dname, darray) = abi.decode(data, (uint, address, string, uint[2]));
}
```

## 哈希函数

solidity 中常用的哈希函数是 `keccak256`，其用法如下:

```solidity
    hash = keccak256(数据)
```

### keccak256 与 sha3

`keccak256` 与 `sha3` 的区别和联系：
- 联系: `sha3` 由 `keccak256` 标准化而来，很多场景可以同义
- 区别: 在 `sha3` 标准化完成时，更改了其内部算法，导致最终结果与 `keccak256` 不一致；以太坊在 `sha3` 标准化之前开发出来，所以以太坊的哈希函数是 `keccak256`

## try-catch

在 solidity 中 try catch 语法，只能用于外部函数或创建合约时 construct 的调用。基本语法如下

```solidity
    try externalContract.f() returns(returnType val) {
        // call 成功时执行
    } catch {
        // call 失败时执行
    }
```

备注:
- `this.f()` 也可被视为外部函数调用