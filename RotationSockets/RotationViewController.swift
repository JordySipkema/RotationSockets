//
//  RotationViewController.swift
//  RotationSockets
//
//  Created by Jordy Sipkema on 19/09/2017.
//  Copyright © 2017 Revcode. All rights reserved.
//

import UIKit

protocol RotationDelegate {
    func update(equalOrientations: Bool)
}

class RotationViewController: UIViewController, DeviceServiceViewDelegate {
    
    let deviceService = DeviceService.instance()

    override func viewDidLoad() {
        super.viewDidLoad()
        deviceService.subscribe(listener: self)
        // Do any additional setup after loading the view.
    }
    
    func UpdateViewDevices(areEqual: Bool){
        if areEqual {
            self.view.backgroundColor = UIColor.green
        } else {
            self.view.backgroundColor = UIColor.red
        }
    }
    
    func UpdateViewDevices(areChanged: Bool){
        // Not implemented, because this view wont use it.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillDisappear(animated)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
