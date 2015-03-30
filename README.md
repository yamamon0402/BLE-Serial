# BLE-Serial
BLE-Serial use in swift.

# installation
>　現状、ファイルを取り込んでもらうのが、一番早いです。
>　Modelsフォルダ以下を全てプロジェクトに取り込んで、
> Linked Frameworks and Libraries にcoreBluetooth.frameworkを追加。
> 
> いずれは、cocoaPodへ

# API
### 接続
```swift
var communicator : BLESerialCommunicator = BLESerialCommunicator.sharedInstance
communicator.connect()
```

> read / writeを実行するには、connectは完了していなければなりません。
>
>参考：TopViewController viewDidLoad()　内

```swift
var communicator : BLESerialCommunicator = BLESerialCommunicator.sharedInstance
communicator.connect()
```

> 使い終わったら必ずdisconnectする

### 読み込み
```swift
var communicator : BLESerialCommunicator = BLESerialCommunicator.sharedInstance
communicator.readBlock = {string in
}
```

> stringにString型で帰ってくる。
> BLE-Serial側でデータ飛ばされるたび、呼ばれる。
>
> 参考：TopViewController viewDidLoad()　内
>　　　　文字列処理がぐちゃぐちゃです。

### 書き込み
```swift
var communicator : BLESerialCommunicator = BLESerialCommunicator.sharedInstance
communicator.write(string:String)
```

> 引数stringを書き込む 256 byte制限
>

# 参考
　
- [BLE-Serial](http://www.robotsfx.com/robot/BLESerial.html)

# License
 MIT license.

