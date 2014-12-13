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
    
    var centralManager:CBCentralManager! //Manager for finding BLE divieces
    var peripheral:CBPeripheral! //Active diviece
    var UUIDInfo: [String : String]!
    var blueToothReady = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.UUIDInfo = self.makeSensorTagConfiguration();
        
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
                println("Service UUID: \(self.serviceLookup((aService as CBService) ))")
                peripheral.discoverCharacteristics(nil, forService: aService as CBService)
        }
        
        
        //self.configureSensorTag()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.deconfigureSensorTag()
    }
    
    
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        
        //This one must be made better
        println("Found Characteristics For Service: \(service.UUID)")
        
        var result = service.UUID.isEqual(CBUUID(string: self.UUIDInfo["Button service UUID"]))
        println("Comparing \(result)")
        if(result){
            self.configureSensorTag()
        }
        
            
        
        /*
        println(self.serviceLookup(service));
        
        for aChar in service.characteristics as [CBCharacteristic]
        {
                var result = service.UUID.isEqual(CBUUID(string: "FFE0"))
                println("Comparing \(result)")
            if(result){
                println("Characteristics UUID: \((aChar as CBCharacteristic).UUID)")
                var sUUID = CBUUID(string: self.UUIDInfo["Button service UUID"]);
                var dUUID = CBUUID(string: self.UUIDInfo["Button data UUID"]);

                println("Should be writing to \(aChar.UUID)")
                println("Is writing to  \(sUUID)")
                
                BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: true)

                //self.peripheral.setNotifyValue(true, forCharacteristic: aChar)
            }
        }
        

        for aChar in service.characteristics as [CBCharacteristic]
        {
            println("Characteristics UUID: \((aChar as CBCharacteristic).UUID)")
            
            if(service.UUID.isEqual(CBUUID(string: UUIDInfo["Accelerometer service UUID"]))){
                println("Found IR temperature service UUID")
                if(UUIDInfo["Accelerometer active"] == "1"){
                    println("Should configure this sensore")
                }
                
            }
            
            if((aChar as CBCharacteristic).UUID.isEqual(CBUUID(string: "F000AA11-0451-4000-B000-000000000000"))){
                println("Found correct tingy with UIID \((aChar as CBCharacteristic).UUID)")
    

                var sUUID = CBUUID(string:"F000AA10-0451-4000-B000-000000000000");
                var dUUID = CBUUID(string:"F000AA11-0451-4000-B000-000000000000");
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

                BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: true)
                //peripheral.setNotifyValue(true, forCharacteristic: aChar as CBCharacteristic)
                //BLEUtility.setNotificationForCharacteristic(self.peripheral, sCBUUID: sUUID, cCBUUID: cUUID, enable: true)

                println("Done seting up tingy")

                
            }

        }
 */
    }
    
    func peripheral(peripheral: CBPeripheral!, didWriteValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        println("didWriteValueForCharacteristic \(characteristic.UUID) error = \(error)");

    }
    
    
    func configureSensorTag(){
    
        
        if(self.UUIDInfo["Ambient temperature active"] == "1" || self.UUIDInfo["IR temperature active"] == "1"){
        
            var sUUID = CBUUID(string: self.UUIDInfo["IR temperature service UUID"]);
            var cUUID = CBUUID(string: self.UUIDInfo["IR temperature config UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["IR temperature data UUID"]);
            
            var dataInt = NSInteger(1) //(1-100)
            var data = NSData(bytes: &dataInt, length: 1)
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)

            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: true)
            
            println("IR temperature service Configured")
        }
    
        if(self.UUIDInfo["Accelerometer active"] == "1"){
            
            var sUUID = CBUUID(string: self.UUIDInfo["Accelerometer service UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["Accelerometer data UUID"]);
            var cUUID = CBUUID(string: self.UUIDInfo["Accelerometer config UUID"]);
            var pUUID = CBUUID(string: self.UUIDInfo["Accelerometer period UUID"]);
            
            var random = NSInteger(50) //(1-100) // Change to the data from UUIDINFO
            var data = NSData(bytes: &random, length: 1)
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: pUUID, data: data)
            
            random = NSInteger(1)
            data = NSData(bytes: &random, length: 1)
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)
            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: true)
        
            println("Accelerometer service Configured")

        }

        if(self.UUIDInfo["Humidity active"] == "1"){
            var sUUID = CBUUID(string: self.UUIDInfo["Humidity service UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["Humidity data UUID"]);
            var cUUID = CBUUID(string: self.UUIDInfo["Humidity config UUID"]);
            
            var dataInt = NSInteger(1) //(1-100)
            var data = NSData(bytes: &dataInt, length: 1)
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)
            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: true)

            println("Humidity service Configured")

        }
        
        if(self.UUIDInfo["Barometer active"] == "1"){
            var sUUID = CBUUID(string: self.UUIDInfo["Barometer service UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["Barometer data UUID"]);
            var cUUID = CBUUID(string: self.UUIDInfo["Barometer config UUID"]);
            var calibrateUUID = CBUUID(string: self.UUIDInfo["Barometer calibration UUID"]);
            
            var dataInt = NSInteger(2) //(1-100)
            var data = NSData(bytes: &dataInt, length: 1)
            
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)
            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: true)

            //Don't know what is happening here but is needed
            BLEUtilitySwift.readCharacteristic(self.peripheral, sUUID: sUUID, cUUID: calibrateUUID)
            
            println("Barometer service Configured")
        }
        
        
        if(self.UUIDInfo["Gyroscope active"] == "1"){
            var sUUID = CBUUID(string: self.UUIDInfo["Gyroscope service UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["Gyroscope data UUID"]);
            var cUUID = CBUUID(string: self.UUIDInfo["Gyroscope config UUID"]);
            
            var dataInt = NSInteger(1) //(1-100)
            var data = NSData(bytes: &dataInt, length: 1)
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)
            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: true)
            
            println("Gyroscope service Configured")
        }
        
        if(self.UUIDInfo["Magnetometer active"] == "1"){
            
            var sUUID = CBUUID(string: self.UUIDInfo["Magnetometer service UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["Magnetometer data UUID"]);
            var cUUID = CBUUID(string: self.UUIDInfo["Magnetometer config UUID"]);
            var pUUID = CBUUID(string: self.UUIDInfo["Magnetometer period UUID"]);
            
            var random = NSInteger(50) //(1-100) // Change to the data from UUIDINFO
            var data = NSData(bytes: &random, length: 1)
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: pUUID, data: data)
            
            random = NSInteger(1)
            data = NSData(bytes: &random, length: 1)
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)
            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: true)

            println("Magnetometer service Configured")

        }
        
        if(self.UUIDInfo["Button active"] == "1"){
            
            var sUUID = CBUUID(string: self.UUIDInfo["Button service UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["Button data UUID"]);
            
            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: true)
            
            println("Button service Configured")
        }
    }
    
    func deconfigureSensorTag(){
    
        if(self.UUIDInfo["Ambient temperature active"] == "1" || self.UUIDInfo["IR temperature active"] == "1"){
            
            var sUUID = CBUUID(string: self.UUIDInfo["IR temperature service UUID"]);
            var cUUID = CBUUID(string: self.UUIDInfo["IR temperature config UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["IR temperature data UUID"]);
            
            var dataInt = NSInteger(0) //(1-100)
            var data = NSData(bytes: &dataInt, length: 1)
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)
            
            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: true)
        }
        
        if(self.UUIDInfo["Accelerometer active"] == "1"){
            
            var sUUID = CBUUID(string: self.UUIDInfo["Accelerometer service UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["Accelerometer data UUID"]);
            var cUUID = CBUUID(string: self.UUIDInfo["Accelerometer config UUID"]);

            var dataInt = NSInteger(0) //(1-100)
            var data = NSData(bytes: &dataInt, length: 1)
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)
            
            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: false)
            
        }
        
        if(self.UUIDInfo["Humidity active"] == "1"){
            var sUUID = CBUUID(string: self.UUIDInfo["Humidity service UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["Humidity data UUID"]);
            var cUUID = CBUUID(string: self.UUIDInfo["Humidity config UUID"]);

            var dataInt = NSInteger(0) //(1-100)
            var data = NSData(bytes: &dataInt, length: 1)
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)
            
            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: false)
        }
        
        if(self.UUIDInfo["Barometer active"] == "1"){
            var sUUID = CBUUID(string: self.UUIDInfo["Barometer service UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["Barometer data UUID"]);
            var cUUID = CBUUID(string: self.UUIDInfo["Barometer config UUID"]);
            
            var dataInt = NSInteger(0) //(1-100)
            var data = NSData(bytes: &dataInt, length: 1)
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)
            
            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: false)

        }
        
        
        if(self.UUIDInfo["Gyroscope active"] == "1"){
            var sUUID = CBUUID(string: self.UUIDInfo["Gyroscope service UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["Gyroscope data UUID"]);
            var cUUID = CBUUID(string: self.UUIDInfo["Gyroscope config UUID"]);

            var dataInt = NSInteger(0) //(1-100)
            var data = NSData(bytes: &dataInt, length: 1)
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)
            
            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: false)
        }
        
        if(self.UUIDInfo["Magnetometer active"] == "1"){
            
            var sUUID = CBUUID(string: self.UUIDInfo["Magnetometer service UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["Magnetometer data UUID"]);
            var cUUID = CBUUID(string: self.UUIDInfo["Magnetometer config UUID"]);
            
            var dataInt = NSInteger(0) //(1-100)
            var data = NSData(bytes: &dataInt, length: 1)
            BLEUtilitySwift.writeCharacteristic(self.peripheral, sUUID: sUUID, cUUID: cUUID, data: data)
            
            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: false)
        }
        
        if(self.UUIDInfo["Button active"] == "1"){
            
            var sUUID = CBUUID(string: self.UUIDInfo["Button service UUID"]);
            var dUUID = CBUUID(string: self.UUIDInfo["Button data UUID"]);
            
            BLEUtilitySwift.setNotificationForCharacteristic(self.peripheral, sUUID: sUUID, cUUID: dUUID, enable: false)
        }
    }
    
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        
        //println("Getting some data or something from: \(characteristic.UUID)")
        
        
        if(characteristic.UUID.isEqual(CBUUID(string: self.UUIDInfo["IR temperature data UUID"]))){
            println("IR temperature data UUID")
            
            var tAmb = sensorTMP006.calcTAmb(characteristic.value)
            var tObj = sensorTMP006.calcTObj(characteristic.value)

            println("Ambient Temperature \(tAmb) Target Temperature \(tObj)")
        }
        if(characteristic.UUID.isEqual(CBUUID(string: self.UUIDInfo["Accelerometer data UUID"]))){
            println("Accelerometer data UUID")
        }
        if(characteristic.UUID.isEqual(CBUUID(string: self.UUIDInfo["Humidity data UUID"]))){
            println("Humidity data UUID")
        }
        if(characteristic.UUID.isEqual(CBUUID(string: self.UUIDInfo["Magnetometer data UUID"]))){
            println("Magnetometer data UUID")
        }
        if(characteristic.UUID.isEqual(CBUUID(string: self.UUIDInfo["Barometer calibration UUID"]))){
            println("Barometer calibration data UUID")
        }
        if(characteristic.UUID.isEqual(CBUUID(string: self.UUIDInfo["Barometer data UUID"]))){
            println("Barometer data UUID")
        }
        if(characteristic.UUID.isEqual(CBUUID(string: self.UUIDInfo["Gyroscope data UUID"]))){
            println("Gyroscope data UUID")
        }
        if(characteristic.UUID.isEqual(CBUUID(string: self.UUIDInfo["Button data UUID"]))){
            println("Button data UUID")
        }

        
        //println("Data: \(characteristic.value)")
        /*
        var x = sensorKXTJ9.calcXValue(characteristic.value)
        var y = sensorKXTJ9.calcXValue(characteristic.value)
        var z = sensorKXTJ9.calcXValue(characteristic.value)
        println("Data X: \(x) Y: \(y) Z: \(z)")
        */
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        println("didUpdateNotificationStateForCharacteristic \(characteristic.UUID), error = \(error)");

    }
    
    func makeSensorTagConfiguration() -> [String : String]{
        var UUIDinfo = [String : String]()
        
        
        // First we set ambient temperature
        UUIDinfo["Ambient temperature active"] = "1";
        // Then we set IR temperature
        UUIDinfo["IR temperature active"] = "1";
        // Append the UUID to make it easy for app
        UUIDinfo["IR temperature service UUID"] = "F000AA00-0451-4000-B000-000000000000";
        UUIDinfo["IR temperature data UUID"] = "F000AA01-0451-4000-B000-000000000000";
        UUIDinfo["IR temperature config UUID"] = "F000AA02-0451-4000-B000-000000000000";

        // Then we setup the accelerometer
        UUIDinfo["Accelerometer active"] = "0";
        UUIDinfo["Accelerometer period"] = "500";
        UUIDinfo["Accelerometer service UUID"] = "F000AA10-0451-4000-B000-000000000000";
        UUIDinfo["Accelerometer data UUID"] = "F000AA11-0451-4000-B000-000000000000";
        UUIDinfo["Accelerometer config UUID"] = "F000AA12-0451-4000-B000-000000000000";
        UUIDinfo["Accelerometer period UUID"] = "F000AA13-0451-4000-B000-000000000000";

        //Then we setup the rH sensor
        UUIDinfo["Humidity active"] = "0";
        UUIDinfo["Humidity service UUID"] = "F000AA20-0451-4000-B000-000000000000";
        UUIDinfo["Humidity data UUID"] = "F000AA21-0451-4000-B000-000000000000";
        UUIDinfo["Humidity config UUID"] = "F000AA22-0451-4000-B000-000000000000";
        
        //Then we setup the magnetometer
        UUIDinfo["Magnetometer active"] = "0";
        UUIDinfo["Magnetometer period"] = "500";
        UUIDinfo["Magnetometer service UUID"] = "F000AA30-0451-4000-B000-000000000000";
        UUIDinfo["Magnetometer data UUID"] = "F000AA31-0451-4000-B000-000000000000";
        UUIDinfo["Magnetometer config UUID"] = "F000AA32-0451-4000-B000-000000000000";
        UUIDinfo["Magnetometer period UUID"] = "F000AA33-0451-4000-B000-000000000000";
        
        //Then we setup the barometric sensor
        UUIDinfo["Barometer active"] = "0";
        UUIDinfo["Barometer service UUID"] = "F000AA40-0451-4000-B000-000000000000";
        UUIDinfo["Barometer data UUID"] = "F000AA41-0451-4000-B000-000000000000";
        UUIDinfo["Barometer config UUID"] = "F000AA42-0451-4000-B000-000000000000";
        UUIDinfo["Barometer calibration UUID"] = "F000AA43-0451-4000-B000-000000000000";
        
        //Then we setup the Gyroscope sensor
        UUIDinfo["Gyroscope active"] = "0";
        UUIDinfo["Gyroscope service UUID"] = "F000AA50-0451-4000-B000-000000000000";
        UUIDinfo["Gyroscope data UUID"] = "F000AA51-0451-4000-B000-000000000000";
        UUIDinfo["Gyroscope config UUID"] = "F000AA52-0451-4000-B000-000000000000";
        
        //Last we setup the button service
        UUIDinfo["Button active"] = "0";
        UUIDinfo["Button service UUID"] = "FFE0";
        UUIDinfo["Button data UUID"] = "FFE1";


        //println("UUIDinfo is set \(UUIDinfo)")
    
        return UUIDinfo;
    }
    
    
    func serviceLookup(sUUID: CBService) -> String{
    
        if(sUUID.UUID.isEqual(CBUUID(string: UUIDInfo["IR temperature service UUID"]))){
            return "IR temperature service";
        }
        
        if(sUUID.UUID.isEqual(CBUUID(string: UUIDInfo["Accelerometer service UUID"]))){
            return "Accelerometer service UUID";
        }
        
        if(sUUID.UUID.isEqual(CBUUID(string: UUIDInfo["Humidity service UUID"]))){
            return "Humidity service UUID";
        }
        
        if(sUUID.UUID.isEqual(CBUUID(string: UUIDInfo["Magnetometer service UUID"]))){
            return "Magnetometer service UUID";
        }
        
        if(sUUID.UUID.isEqual(CBUUID(string: UUIDInfo["Barometer service UUID"]))){
            return "Barometer service UUID";
        }
        
        if(sUUID.UUID.isEqual(CBUUID(string: UUIDInfo["Gyroscope service UUID"]))){
            return "Gyroscope service UUID";
        }
        if(sUUID.UUID.isEqual(CBUUID(string: UUIDInfo["Button service UUID"]))){
            return "Button service UUID";
        }
        return "Service not found"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
