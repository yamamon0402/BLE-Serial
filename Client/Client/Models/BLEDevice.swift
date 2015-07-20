//
//  BLEDevice.swift
//  Client
//
//  Created by 山本　恭大 on 2015/02/16.
//  Copyright (c) 2015年 山本　恭大. All rights reserved.
//

import UIKit
import CoreBluetooth

//CBPeripheralのラッパーかつ、デリゲートの受取場

class BLEDevice: NSObject , CBPeripheralDelegate {
    
    // MARK: - API(property) -
    var localName : NSString?
    var txPowerLevel : NSNumber?
    var serviceUUIDs : NSArray?
    var isConnectable : Bool?
    
    // サービスが見つかったクロージャー 何かの癖でblockと書いてしまう
    var discoverServiceBlock: (CBService) -> Void = {service in}
    var discoverCharactaristicBlock : (CBService) -> Void = {service in}
    
    // characteristicが更新されたクローじゃ
    var updateCharacteristicBlock: (CBCharacteristic) -> Void = {Charactaristic in}
    
    var peripheral : CBPeripheral!
    
    var identifier : String!{
        get{
            if var peri:CBPeripheral = peripheral
            {
                return peri.identifier.UUIDString
            }
            else
            {
                return ""
            }
        }
    }
    var name : String!{
        get{
            if var peri:CBPeripheral = peripheral
            {
                return peri.name
            }
            else
            {
                return ""
            }
        }
        set{
        }
    }
    
    
    
    var state :CBPeripheralState!{
        get{
            if var peri:CBPeripheral = peripheral
            {
                return peri.state
            }
            else
            {
                return CBPeripheralState.Disconnected
            }
        }
        set{
        }
    }
    
    var services :NSArray!{
        get{
            if var peri:CBPeripheral = peripheral
            {
                return peri.services as NSArray
            }
            else
            {
                return NSArray.alloc()
            }
        }
        set{
        }
    }
    
    
    var RSSI : Int!{
        get{
            if var peri:CBPeripheral = peripheral
            {
                return peri.RSSI.integerValue
            }
            else
            {
                return self.RSSI
            }
        }
        set{
            //self.RSSI = newValue
        }
    }
    
    
    init(peripheral:CBPeripheral,advertismentData:NSDictionary,rssi:NSNumber)
    {
        super.init()
        localName = advertismentData["kCBAdvDataLocalName"] as? NSString
        txPowerLevel = advertismentData["kCBAdvDataTxPowerLevel"] as? NSNumber
        serviceUUIDs = advertismentData["kCBAdvDataServiceUUIDs"] as? NSArray
        let local_isConnectable = advertismentData["kCBAdvDataIsConnectable"] as? NSNumber
        isConnectable = local_isConnectable?.boolValue
        
        RSSI = rssi.integerValue
        println("\(advertismentData)")
        self.peripheral = peripheral
        self.peripheral.delegate = self
    }
    
    // MARK: - CBPeripheralDelegate -
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        self.peripheral = peripheral;
        for service in self.peripheral.services	{
            //サービスが見つかったらすぐにキャラクタリスティックも探す
            self.peripheral.discoverCharacteristics(nil, forService: service as! CBService)
            
            discoverServiceBlock(service as! CBService)
        }
        println("discover service")
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        discoverCharactaristicBlock(service)
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        updateCharacteristicBlock(characteristic)
    }
    
    // MARK: - API -
    
    // serviceのUUIDとcharacteristicsのUUIDから欲しいデータを取り出す。
    // serviceはconnect済みであることが条件
    func getCharacteristic(serviceUUID : NSString , CharacteristicUUID : NSString) -> CBCharacteristic?
    {
        if state == CBPeripheralState.Connected
        {
            for service in services // 高速列挙でキャストする方法ってないのかな？勉強不足
            {
                //println("getch:\((service as! CBService).UUID.UUIDString) , \(serviceUUID) , ")
                if (service as! CBService).UUID.UUIDString.lowercaseString == serviceUUID
                {
                    if (service as! CBService).characteristics != nil
                    {
                        for characteristic in (service as! CBService).characteristics // 高速列挙でキャストする方法ってないのかな？
                        {
                            if (characteristic as! CBCharacteristic).UUID.UUIDString.lowercaseString == CharacteristicUUID
                            {
                                return characteristic as? CBCharacteristic;
                            }
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func writeWithResponse(characteristic : CBCharacteristic , value : NSData)
    {
        peripheral.writeValue(value, forCharacteristic: characteristic, type: CBCharacteristicWriteType.WithResponse)
    }
    
    func writeWithoutResponse(characteristic : CBCharacteristic , value : NSData)
    {
        peripheral.writeValue(value, forCharacteristic: characteristic, type: CBCharacteristicWriteType.WithoutResponse)
    }
    
    func readRequest(characteristic : CBCharacteristic)
    {
        peripheral.readValueForCharacteristic(characteristic)
    }
    
    func notifyRequest(characteristic : CBCharacteristic)
    {
        peripheral.setNotifyValue(true, forCharacteristic: characteristic)
    }
    
}
