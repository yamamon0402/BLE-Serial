//
//  BLESerialCommunicator.swift
//  Client
//
//  Created by 山本　恭大 on 2015/03/24.
//  Copyright (c) 2015年 山本　恭大. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLESerialCommunicator: NSObject {
    
    let BLESERIAL_NAME = "BLESerial"
    let UUID_VSP_SERVICE = "569a1101-b87f-490c-92cb-11ba5ea5167c" //VSP
    let UUID_RX = "569a2001-b87f-490c-92cb-11ba5ea5167c" //RX
    let UUID_TX = "569a2000-b87f-490c-92cb-11ba5ea5167c" //TX
    
    // txの文字列を受診したらその文字列をコールバックする
    var readBlock: (String) -> Void = {string in}
    var localDevice : BLEDevice?
    
    class var sharedInstance : BLESerialCommunicator {
        struct Static {
            static let instance : BLESerialCommunicator = BLESerialCommunicator()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
    }
    
    func connect()
    {
        var manager:BLEManager = BLEManager.sharedInstance
        
        while manager.scanDevices(UUID_VSP_SERVICE) == false
        {
            NSRunLoop.currentRunLoop().runUntilDate(NSDate(timeIntervalSinceNow: 0.1))
        }
        manager.discoverBlock = {device in
            if (device as BLEDevice).name == self.BLESERIAL_NAME //デバイスが見つかったらscanを止めて接続
            {
                manager.stopScan()
                manager.connect(self.UUID_VSP_SERVICE)
                
                
                (device as BLEDevice).discoverServiceBlock = {service in
                }
                
                (device as BLEDevice).discoverCharactaristicBlock = {service in
                    self.localDevice = (device as BLEDevice)
                    for ch in (service as CBService).characteristics
                    {
                        var tx : CBCharacteristic? = (device as BLEDevice).getCharacteristic(self.UUID_VSP_SERVICE, CharacteristicUUID: self.UUID_TX)
                        if (ch as CBCharacteristic) == tx
                        {
                            (device as BLEDevice).notifyRequest(tx!)
                        }
                    }
                }
                
                (device as BLEDevice).updateCharacteristicBlock = { charactaristic in
                    self.localDevice = (device as BLEDevice)
                    var rx : CBCharacteristic? = (device as BLEDevice).getCharacteristic(self.UUID_VSP_SERVICE, CharacteristicUUID: self.UUID_RX)
                    if charactaristic as CBCharacteristic == rx
                    {
                        return
                    }
                    
                    var tx : CBCharacteristic? = (device as BLEDevice).getCharacteristic(self.UUID_VSP_SERVICE, CharacteristicUUID: self.UUID_TX)
                    if charactaristic as CBCharacteristic == tx
                    {
                        if tx?.value != nil
                        {
                            var source : String = NSString(data:(tx?.value)! , encoding:NSUTF8StringEncoding)!
                            println("\(source)")
                            self.readBlock(source)
                        }
                    }
                }
            }
            
        }
    }
    
    func write(string : String){
        
        var rx : CBCharacteristic? = localDevice?.getCharacteristic(self.UUID_VSP_SERVICE, CharacteristicUUID: self.UUID_RX)
        var data : NSData = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        localDevice?.writeWithoutResponse(rx!, value: data)
    }
    
    func disconnect()
    {
        var manager:BLEManager = BLEManager.sharedInstance
        manager.disconnect(self.UUID_VSP_SERVICE)
    }
    
}
