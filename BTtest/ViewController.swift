//
//  ViewController.swift
//  BTtest
//
//  Created by Theodor Brandt on 2014-12-10.
//  Copyright (c) 2014 Theodor Brandt. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager:CBCentralManager!
    var peripheral:CBPeripheral!
    var BLEUtil = BLEUtility();
    
    var blueToothReady = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startUpCentralManager()
    }
    
    func startUpCentralManager() {
        println("Initializing central manager")
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func discoverDevices() {
        println("discovering devices")
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        println("Discovered \(peripheral.name)")
        println("identifier \(peripheral.identifier)")
        println("services \(peripheral.services)")
        println("RSSI \(RSSI)")
        
        self.peripheral = peripheral;

        central.connectPeripheral(self.peripheral, options: nil)
        
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        
        self.peripheral.delegate = self;
        self.peripheral.discoverServices(nil)
        println("Connected")
        
    }
    
    func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        println("disConnected")
        
        self.peripheral = nil;
        startUpCentralManager()

    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        println("checking state")
        blueToothReady = false;
        switch (central.state) {
        case .PoweredOff:
            println("CoreBluetooth BLE hardware is powered off")
            
        case .PoweredOn:
            println("CoreBluetooth BLE hardware is powered on and ready")
            blueToothReady = true;
            
        case .Resetting:
            println("CoreBluetooth BLE hardware is resetting")
            
        case .Unauthorized:
            println("CoreBluetooth BLE state is unauthorized")
            
        case .Unknown:
            println("CoreBluetooth BLE state is unknown");
            
        case .Unsupported:
            println("CoreBluetooth BLE hardware is unsupported on this platform");
            
        }
        if blueToothReady {
            discoverDevices()
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        
        println("Hello from deligate \(peripheral.name)");
        
        for aService in peripheral.services{
                println("Service UUID: \((aService as CBService).UUID )")
                peripheral.discoverCharacteristics(nil, forService: aService as CBService)
        }
        
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        
        //This one must be made better
        println("Found Characteristics For Service: \(service.UUID)")
        for aChar in service.characteristics
        {
            
            println("Characteristics UUID: \((aChar as CBCharacteristic).UUID)")
            if((aChar as CBCharacteristic).UUID.isEqual(CBUUID(string: "F000AA11-0451-4000-B000-000000000000"))){
                println("Found correct tingy")
                

                var sUUID = CBUUID(string:"F000AA10-0451-4000-B000-000000000000");
                var dUUID = CBUUID(string:"F000AA10-0451-4000-B000-000000000000");
                var cUUID = CBUUID(string:"F000AA12-0451-4000-B000-000000000000");
                var pUUID = CBUUID(string:"F000AA13-0451-4000-B000-000000000000");

                
                
                var random = NSInteger(50) //(1-100)
                var data = NSData(bytes: &random, length: 1)
                BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: pUUID, data: data)
                //BLEUtility.writeCharacteristic(self.peripheral, sCBUUID: sUUID, cCBUUID: pUUID, data: data)
                //peripheral.writeValue(data, forCharacteristic: cUUID, type: CBCharacteristicWriteType.WithResponse)
                
                random = NSInteger(1)
                data = NSData(bytes: &random, length: 1)
                BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)
                //BLEUtility.writeCharacteristic(self.peripheral, sCBUUID: sUUID, cCBUUID: cUUID, data: data)

                BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, enable: true)
                //peripheral.setNotifyValue(true, forCharacteristic: aChar as CBCharacteristic)
                //BLEUtility.setNotificationForCharacteristic(self.peripheral, sCBUUID: sUUID, cCBUUID: cUUID, enable: true)

                println("Done seting up tingy")

                
            }
            
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didWriteValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        println("didWriteValueForCharacteristic \(characteristic.UUID) error = \(error)");

    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        println("Getting some data or something from: \(characteristic.UUID)")
        //println("Data: \(characteristic.value)")
        
        var x = sensorKXTJ9.calcXValue(characteristic.value)
        var y = sensorKXTJ9.calcXValue(characteristic.value)
        var z = sensorKXTJ9.calcXValue(characteristic.value)
        println("Data X: \(x) Y: \(y) Z: \(z)")

    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        println("didUpdateNotificationStateForCharacteristic \(characteristic.UUID), error = \(error)");

    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
