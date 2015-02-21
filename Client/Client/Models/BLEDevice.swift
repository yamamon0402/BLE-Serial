//
//  BLEDevice.swift
//  Client
//
//  Created by 山本　恭大 on 2015/02/16.
//  Copyright (c) 2015年 山本　恭大. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEDevice: NSObject , CBPeripheralDelegate {
    
    var localName : NSString?
    var txPowerLevel : NSNumber?
    var serviceUUIDs : NSArray?
    var isConnectable : Bool?
    
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
        
    }
    
}
