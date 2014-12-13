//
//  BLEUtilitySwift.swift
//  BTtest
//
//  Created by Theodor Brandt on 2014-12-12.
//  Copyright (c) 2014 Theodor Brandt. All rights reserved.
//

import Foundation
import CoreBluetooth

class BLEUtilitySwift: NSObject {
    
    class func writeCharacteristic(peripheral:CBPeripheral, sUUID: String, cUUID: String, data: NSData){
        for service in peripheral.services as [CBService] {
            if(service.UUID == CBUUID(string: sUUID)){ //Might need to check this
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == CBUUID(string: cUUID)){ //Might need to check this
                        /* EVERYTHING IS FOUND, WRITE characteristic ! */
                        //println("EVERYTHING IS FOUND, WRITE characteristic") // Remove when done
                        peripheral.writeValue(data, forCharacteristic: characteristic, type: CBCharacteristicWriteType.WithResponse)
                    }
                }
            }
        }
    }
    
    class func writeCharacteristic(peripheral:CBPeripheral, sUUID: CBUUID, cUUID: CBUUID, data: NSData){
        for service in peripheral.services as [CBService] {
            if(service.UUID == sUUID){
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == cUUID){
                        /* EVERYTHING IS FOUND, WRITE characteristic ! */
                        //println("EVERYTHING IS FOUND, WRITE characteristic") // Remove when done
                        peripheral.writeValue(data, forCharacteristic: characteristic, type: CBCharacteristicWriteType.WithResponse)
                    }
                }
            }
        }
    }
    
    class func readCharacteristic(peripheral:CBPeripheral, sUUID: String, cUUID: String){
        for service in peripheral.services as [CBService] {
            if(service.UUID == CBUUID(string: sUUID)){ //Might need to check this
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == CBUUID(string: cUUID)){ //Might need to check this
                        /* Everything is found, read characteristic ! */
                        //println("Everything is found, read characteristic !") // Remove when done
                        peripheral.readValueForCharacteristic(characteristic)
                    }
                }
            }
        }
    }
    
    class func readCharacteristic(peripheral:CBPeripheral, sUUID: CBUUID, cUUID: CBUUID){
        for service in peripheral.services as [CBService] {
            if(service.UUID == sUUID){
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == cUUID){
                        /* Everything is found, read characteristic ! */
                        //println("Everything is found, read characteristic !") // Remove when done
                        peripheral.readValueForCharacteristic(characteristic)

                    }
                }
            }
        }
    }
    
    class func setNotificationForCharacteristic(peripheral:CBPeripheral, sUUID: String, cUUID: String, enable: Bool){
        //println("setNotificationForCharacteristic with String") // Remove when done

        for service in peripheral.services as [CBService] {
            if(service.UUID == CBUUID(string: sUUID)){ //Might need to check this
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == CBUUID(string: cUUID)){ //Might need to check this
                        /* Everything is found, set notification ! */
                        //println("Everything is found, set notification !") // Remove when done
                        peripheral.setNotifyValue(enable, forCharacteristic: characteristic)
                    }
                }
            }
        }
    }
    
    class func setNotificationForCharacteristic(peripheral:CBPeripheral, sUUID: CBUUID, cUUID: CBUUID, enable: Bool){
        //println("setNotificationForCharacteristic with UUID") // Remove when done

        for service in peripheral.services as [CBService] {
            if(service.UUID == sUUID){
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == cUUID){
                        /* Everything is found, set notification ! */
                        //println("Everything is found, set notification !") // Remove when done
                        peripheral.setNotifyValue(enable, forCharacteristic: characteristic)
                    }
                }
            }
        }
    }
    
    class func isCharacteristicNotifiable(peripheral:CBPeripheral, sUUID: CBUUID, cUUID: CBUUID) -> Bool{
        for service in peripheral.services as [CBService] {
            if(service.UUID == sUUID){
                for characteristic in service.characteristics as [CBCharacteristic]{
                    if(characteristic.UUID == cUUID){

                        if(characteristic.properties == CBCharacteristicProperties.Notify){
                            return true
                        }else{
                            return false
                        }
                    }
                }
            }
        }
        return false;
    }
    

}