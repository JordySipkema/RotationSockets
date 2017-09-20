//
//  ViewController.swift
//  RotationSockets
//
//  Created by Jordy Sipkema on 19/09/2017.
//  Copyright © 2017 Revcode. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonClick(_ sender: Any) {
        if self.view.backgroundColor == UIColor.green {
            self.view.backgroundColor = UIColor.red
        } else {
            self.view.backgroundColor = UIColor.green
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

