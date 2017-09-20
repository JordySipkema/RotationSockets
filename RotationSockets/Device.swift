//
//  Device.swift
//  RotationSockets
//
//  Created by Jordy Sipkema on 19/09/2017.
//  Copyright © 2017 Revcode. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

protocol DeviceEventListener {
    func DeviceDidChangeEvent(object: Device)
}

class Device: Equatable {
   
    enum Orientation { case Portrait, Landscape }
    enum OS { case iOS, Android }
    
    var name : String
    var os : OS
    var orientation : Orientation
    var isSelf : Bool
    
    var eventListener: DeviceEventListener?
    
    init(deviceName: String, os: OS, orientation : Orientation = Orientation.Portrait, isSelf : Bool = false){
        self.name = deviceName
        self.os = os
        self.orientation = orientation
        self.isSelf = isSelf
        if self.isSelf {
            NotificationCenter.default.addObserver(self, selector: #selector(onDeviceRotate), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        }
    }
    
    init(dictionary dict: [String: Any]){
        self.name = dict["deviceName"] as! String
        self.os = (dict["deviceType"] as! String) == "IPHONE" ? Device.OS.iOS : Device.OS.Android
        self.orientation = (dict["deviceState"] as! String) == "PORTRAIT" ? Device.Orientation.Portrait : Device.Orientation.Landscape
        self.isSelf = false
    }
    
    init(json: JSON){
        self.name = json["deviceName"].stringValue
        self.orientation = json["deviceState"].stringValue == "PORTRAIT" ? Device.Orientation.Portrait : Device.Orientation.Landscape
        self.os = json["deviceType"].stringValue == "IPHONE" ? Device.OS.iOS : Device.OS.Android
        self.isSelf = false;
    }
    
    @objc
    func onDeviceRotate(){
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            update(orientation: Orientation.Portrait)
        } else if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            update(orientation: Orientation.Landscape)
        }
    }
    
    func update(orientation : Orientation){
        self.orientation = orientation
        self.eventListener?.DeviceDidChangeEvent(object: self)
        print("Orientation of device \(self.name) changed to \(self.orientation == Orientation.Portrait ? "Portrait" : "Landscape")")
    }
    
    func toJson() -> JSON{
        var json = JSON()
        json["deviceName"].string = self.name
        json["deviceState"].string = self.orientation == Device.Orientation.Portrait ? "PORTRAIT" : "LANDSCAPE"
        json["deviceType"].string = self.os == Device.OS.iOS ? "IPHONE" : "ANDROID"
        
        return json
    }
    
    func subscribe(listener: DeviceEventListener){
        self.eventListener = listener
    }
    
    func unsubscribe(){
        self.eventListener = nil
    }
    
    // Prototype: Equatable
    static func ==(lhs: Device, rhs: Device) -> Bool {
        return lhs.name == rhs.name
    }
    
    deinit {
        // Very important; remove the observer. Not doing this can cause memory-leaks
        NotificationCenter.default.removeObserver(self)
    }
}
