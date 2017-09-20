//
//  DeviceService.swift
//  RotationSockets
//
//  Created by Jordy Sipkema on 19/09/2017.
//  Copyright © 2017 Revcode. All rights reserved.
//

import Foundation
import UIKit.UIDevice
import SocketIO
import SwiftyJSON

protocol DeviceServiceViewDelegate {
    func UpdateViewDevices(areEqual: Bool)
    func UpdateViewDevices(areChanged: Bool)
}

class DeviceService: DeviceEventListener {
    
    // Set up the singleton
    private static let singleton : DeviceService = DeviceService()
    static func instance() -> DeviceService { return singleton }
    
    // The view that is acting as a EventListener.
    private var eventDelegate : DeviceServiceViewDelegate? = nil
    let socket = SocketIOClient(socketURL: URL(string:"https://rotations.jordify.nl")!)
    
    var devices : [Device] = []
    
    private init() {
        let thisDevice = Device.init(deviceName: UIDevice.current.name, os: Device.OS.iOS, orientation: Device.Orientation.Portrait, isSelf: true)
        thisDevice.subscribe(listener: self)
        devices.append(thisDevice)
        
        addSocketHandlers()
        socket.connect()
        
//        let fakeAndroidDevice = Device.init(deviceName: "FakeAndroidPhone", os: Device.OS.Android, orientation: Device.Orientation.Landscape)
//        thisDevice.subscribe(listener: self)
//        devices.append(fakeAndroidDevice)
    }
    
    func registerDevice(device: Device) {
        socket.emit("connect device", device.toJson().rawString()!)
    }
    
    func addSocketHandlers() {
        socket.on("device connected") {[weak self] data, ack in
            self?.handleConnectOrRotate(isUpdate: false, data: data)
            return
        }
        socket.on("rotation change") {[weak self] data, ack in
            self?.handleConnectOrRotate(isUpdate: true, data: data)
            return
        }
    }
    
    func handleConnectOrRotate(isUpdate: Bool, data: [Any]){
        print("\(#function)")
        var deviceObject: Device? = nil
        
        if let arr = data as? [[String: Any]] {
            var json = JSON()
            json.dictionaryObject = arr.first!
            
            deviceObject = Device.init(dictionary: arr.first!)
        }
        
        // Cancel execution when device is nil.
        if deviceObject == nil { return }
        
        let possibleIndex = devices.index(of: deviceObject!)
        if let index = possibleIndex {
            devices[index].update(orientation: deviceObject!.orientation)
        } else {
            deviceObject!.subscribe(listener: self)
            devices.append(deviceObject!)
        }
    }
    
    // Callback function (Protcol DeviceEventListener)
    func DeviceDidChangeEvent(object: Device) {
        print("\(#function)")
        checkOrientationAndUpdateUI()
        emitDeviceChangeEvent(object: object)
    }
    
    // Checks if all orientations are equal and notifies the UI afterwards.
    func checkOrientationAndUpdateUI() {
        let firstOrientation = devices.first!.orientation
        var equalState = true
        
        for device in devices {
            equalState = equalState && (firstOrientation == device.orientation)
        }
        
        self.eventDelegate?.UpdateViewDevices(areEqual: equalState)
    }
    
    func emitDeviceChangeEvent(object: Device){
        if (object.isSelf){
            socket.emit("rotation change", object.toJson().rawString()!)
        }
    }
    
    // Functions to register a view as DeviceServiceViewDelegate
    func subscribe(listener: DeviceServiceViewDelegate ){
        self.eventDelegate = listener
    }
    
    func unsubscribe(){
        self.eventDelegate = nil
    }
    
    deinit {
        socket.disconnect()
    }
    
    
}
