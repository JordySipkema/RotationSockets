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
    
    func addSocketHandlers() {
        socket.on("device connected") {[weak self] data, ack in
            self?.handleConnectOrRotate(data: data)
            return
        }
        socket.on("rotation change") {[weak self] data, ack in
            self?.handleConnectOrRotate(data: data)
            return
        }
    }
    
    func handleConnectOrRotate(data: [Any]){
        if let arr = data as? [[String: Any]] {
            var json = JSON()
            json.dictionaryObject = arr.first!
            print(json.rawValue)
        }
    }
    
    // Callback function (Protcol DeviceEventListener)
    func DeviceDidChangeEvent(object: Device) {
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
    }
    
    func emitDeviceChangeEvent(object: Device){
        if (object.isSelf){
            var json = JSON()
            json["deviceName"].string = object.name
            json["deviceState"].string = object.orientation == Device.Orientation.Portrait ? "PORTRAIT" : "LANDSCAPE"
            json["deviceType"].string = object.os == Device.OS.iOS ? "IPHONE" : "ANDROID"
            
            socket.emit("rotation change", json.rawString()!)
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
