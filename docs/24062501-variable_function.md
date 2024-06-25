# 函数及变量

- [函数及变量](#函数及变量)
  - [函数](#函数)
    - [函数的可见性](#函数的可见性)
      - [函数可见性图例](#函数可见性图例)
    - [函数的功能](#函数的功能)
  - [变量](#变量)
    - [变量的可见性](#变量的可见性)
    - [变量的存储范围](#变量的存储范围)
    - [变量的作用域](#变量的作用域)


## 函数

### 函数的可见性

函数的可见性，使用以下关键字来修饰:

- `public`: 合约内外均可访问
- `private`: 只能在当前合约内部访问
- `internal`: 在合约内部或者子合约中可访问
- `external`: 只能在当前合约外部访问(但是可以使用 `this.f()` 来调用, `f` 函数名)

#### 函数可见性图例

```solidity
contract MainContract {

    function publicFn() public {
        _;
    }

    function privateFn() private {
        _;
    }

    function internalFn() internal {
        _;
    }

    function externalFn() external {

    }
}
```

```solidity
contract ChildContract is MainContract {
    function x() public {
        publicFn();
        internalFn();
    }
}
```

```solidity
contract ThirdpartyContract {
    function x() public {
        MainContract(mainContractAddress).publicFn();
        MainContract(mainContractAddress).externalFn();
    }
}
```

### 函数的功能

函数有以下功能的关键字：

- `payable`: 标识通过调用此函数，可以向合约转本链 token
- `view`: 标识函数不改变链上状态，能读取但不能修改存储在链上的状态变量
- `pure`: 标识函数不改变链上状态，既不能读取也不能写入存储在链上的状态变量

## 变量

### 变量的可见性

- `public`: 合约内外均可访问
- `private`: 只能在当前合约内部访问
- `internal`: 在合约内部或者子合约中可访问

### 变量的存储范围

变量有以下存储范围:

- `storage`: 存储在链上，合约中状态变量，一般都是默认此值
- `memory`: 临时存储，存储在内存中，不上链，函数的参数和函数中的变量，一般都是此值
- `calldata`: 临时存储，存储在内存中，且不可修改，一般用于声明函数的参数

### 变量的作用域

变量按作用域来划分，可分为 3 类: 状态变量，局部变量，全局变量

- 状态变量: 在合约内的函数均可访问，在合约内、函数外声明，存储在链上
- 局部变量: 仅在函数执行过程中有效的变量，在函数内声明，存储在内存中不上链
- 全局变量: 在全局范围内工作的变量，都是 `solidity` 预留关键字，可以不在函数中声明直接使用。完整全局变量详见: [special-variables-and-functions](https://learnblockchain.cn/docs/solidity/units-and-global-variables.html#special-variables-and-functions)

