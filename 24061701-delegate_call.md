# delegateCall

## call & delegateCall

### call

```mermaid
flowchart LR
    caller[调用者 A]
    proxy[合约 B <br> msg.sender=A.addr <br> msg.value=A.value <br> context=B]
    logic[合约 C <br> msg.sender=B.addr <br> msg.value=B.value <br> context=C]

    caller --call--> proxy -- call--> logic
```

> context: 包含状态及变量的环境，状态变量更改产生的效果，会作用在此环境上

### delegateCall
```mermaid
flowchart LR
    caller[调用者 A]
    c_b[合约 B <br> msg.sender=A.addr <br> msg.value=A.value <br> context=B]
    c_c[合约 C <br> msg.sender=A.addr <br> msg.value=A.value <br> context=B]

    caller --call--> c_b --delegate call--> c_c
```

### delegateCall 应用场景

- 代理合约(Proxy Contract): logic contract 与 proxy contract 有着相同的变量定义，proxy contract 存储变量，但变量的更改是由 logic contract 中的方法来改变的
