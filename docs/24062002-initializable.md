# Initializable

- [Initializable](#initializable)


OpenZeppelin 提供了 Initializable 库合约，该合约的功能是实现通用可升级代理合约，所有需要设计可升级的合约只需要继承 Initialzable 合约即可。

该合约的使用要点为:

- 所有继承了 initializable 合约的子合约，不能够有 `construct(xxx)` 构造函数，需要采用 `initialize(xxx)` 函数完成初始化工作；
- 子合约的 `initialize(xxx)` 函数需要使用 `initializer` 修饰符来修饰，以保证改方法只能被调用一次
- 如果父合约继承了 initializable，那么父合约的 `initialize(xxx)` 函数采用 `onlyInitializing` 来修饰

Ref:
- [https://blog.dteam.top/posts/2023-01/solidity-indefinitive-guide-part5.html](https://blog.dteam.top/posts/2023-01/solidity-indefinitive-guide-part5.html)

