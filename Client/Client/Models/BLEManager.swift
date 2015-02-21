//
//  BLEManager.swift
//  Client
//
//  Created by 山本　恭大 on 2015/02/16.
//  Copyright (c) 2015年 山本　恭大. All rights reserved.
//

import UIKit
import CoreBluetooth

class BLEManager: NSObject,CBCentralManagerDelegate {
    
    var centralManager : CBCentralManager!
    var devices : NSMutableArray = NSMutableArray() // <BLEDevice>
    
    var discoverBlock: () -> Void = {}
    
    var isScannning : Bool = false
    
    class var sharedInstance : BLEManager {
        struct Static {
            static let instance : BLEManager = BLEManager()
        }
        return Static.instance
    }
    
    override init() {
        super.init()
        
        // serial queueで通信
        centralManager = CBCentralManager(delegate: self, queue: dispatch_queue_create("jp.co.BLEClient", DISPATCH_QUEUE_SERIAL))
    }
    
    // MARK: - API -
    
    /**
    デバイスを探す。終わったらstopScanをセットで呼ぶ
    
    :param: uuid そのuuidのデバイス（ペリフェラル）を探す。空文字を渡すと全てのデバイスをスキャンする
    :return: scanに成功したか
    
    */
    func scanDevices(uuid:NSString) -> Bool
    {
        if centralManager.state == CBCentralManagerState.PoweredOn
        {
            var services :NSArray! = nil
            if(uuid != "")
            {
                services = NSArray(object: CBUUID(string: uuid))
                centralManager.scanForPeripheralsWithServices(services, options: nil)
            }
            else
            {
                centralManager.scanForPeripheralsWithServices(nil, options: nil)
            }
            isScannning = true
            NSLog("%d",isScannning)
            return true
        }
        return false
    }
    
    /**
    デバイスのスキャンを止める。
    scanDevicesとセットで必ず呼ぶ。
    */
    func stopScan()
    {
        if isScannning == true
        {
            centralManager.stopScan()
            isScannning = false
        }
    }
    
    // MARK: - CBCentralManagerDelegate -
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        println("\(central.state.name)")
    }
    
    // scanを始めた後、ペリフェラルが見つかったら呼ばれるdelegate
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        
        //同じやつがなければ、追加する
        if advertisementData["kCBAdvDataLocalName"] as? NSString != nil
        {
            var newDevice = BLEDevice(peripheral: peripheral, advertismentData: advertisementData, rssi: RSSI)
            devices.addObject(newDevice)
            discoverBlock()
        }
    }
    
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        
    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        
    }
}
