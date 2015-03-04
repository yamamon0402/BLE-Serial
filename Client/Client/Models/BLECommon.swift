//
//  BLECommon.swift
//  Client
//
//  Created by 山本　恭大 on 2015/02/16.
//  Copyright (c) 2015年 山本　恭大. All rights reserved.
//

// 参考サイト：http://qiita.com/__moai/items/84e5789342840d862305

import UIKit
import CoreBluetooth


// ログをかき出すためにEnumを拡張
extension CBCentralManagerState
{
    var name : NSString {
        get{
            var enumName = "CBCentralManagerState"
            var valueName = ""
            
            switch self {
            case .PoweredOff:
                valueName = enumName + "PoweredOff"
            case .PoweredOn:
                valueName = enumName + "PoweredOn"
            case .Resetting:
                valueName = enumName + "Resetting"
            case .Unauthorized:
                valueName = enumName + "Unauthorized"
            case .Unknown:
                valueName = enumName + "Unknown"
            case .Unsupported:
                valueName = enumName + "Unsupported"
            }
            
            return valueName
        }
    }
}

extension CBPeripheralState
{
    var name : NSString {
        get{
            var enumName = "CBPeripheralState"
            var valueName = ""
            
            switch self {
            case .Connected:
                valueName = enumName + "Connected"
            case .Connecting:
                valueName = enumName + "Connecting"
            case .Disconnected:
                valueName = enumName + "Disconnected"
            }
            
            return valueName
        }
    }
}

extension CBPeripheralManagerState
{
    var name : NSString {
        get{
            var enumName = "CBPeripheralManagerState"
            var valueName = ""
            
            switch self {
            case .PoweredOff:
                valueName = enumName + "PoweredOff"
            case .PoweredOn:
                valueName = enumName + "PoweredOn"
            case .Resetting:
                valueName = enumName + "Resetting"
            case .Unauthorized:
                valueName = enumName + "Unauthorized"
            case .Unknown:
                valueName = enumName + "Unknown"
            case .Unsupported:
                valueName = enumName + "Unsupported"
            }
            
            return valueName
        }
    }
}


