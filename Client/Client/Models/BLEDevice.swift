//
//  BLEDevice.swift
//  Client
//
//  Created by 山本　恭大 on 2015/02/16.
//  Copyright (c) 2015年 山本　恭大. All rights reserved.
//

import UIKit
import CoreBluetooth

enum STATE {
    case disconnect
    case connect
    case Other
}

class BLEDevice: NSObject , CBPeripheralDelegate {
    
    var localName : NSString?
    var txPowerLevel : NSNumber?
    var serviceUUIDs : NSArray?
    var isConnectable : Bool?
    
    var discoverServiceBlock: () -> Void = {}
    
    var state : STATE = .disconnect
    
    var peripheral : CBPeripheral!
    
    var RSSI : Int!
    
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
            self.peripheral.discoverCharacteristics(nil, forService: service as CBService)
            discoverServiceBlock()
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
    }
    
    /*
    func getCharacteristic(serviceUUID : NSString , CharacteristicUUID : NSString) -> CBCharacteristic
    {
        return
    }
    */
    
}
