//
//  DevicesTableViewController.swift
//  RotationSockets
//
//  Created by Jordy Sipkema on 19/09/2017.
//  Copyright © 2017 Revcode. All rights reserved.
//

import UIKit

class DeviceInfoCell: UITableViewCell {
    @IBOutlet weak var OSIcon: UIImageView!
    @IBOutlet weak var DeviceName: UILabel!
    @IBOutlet weak var DeviceState: UILabel!
}

class DevicesTableViewController: UITableViewController, DeviceServiceViewDelegate {
 
    let deviceService = DeviceService.instance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceService.subscribe(listener: self)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func UpdateViewDevices(areEqual: Bool) {
        self.tableView.reloadData()
    }
    
    func UpdateViewDevices(areChanged: Bool) {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return deviceService.devices.count
    }

    func getDeviceForIndexPath(indexPath: IndexPath) -> Device {
        return deviceService.devices[(indexPath as NSIndexPath).item]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceInfoCell", for: indexPath) as! DeviceInfoCell

        // Configure the cell...
        let device = getDeviceForIndexPath(indexPath: indexPath)
        cell.DeviceName.text = device.name
        cell.DeviceState.text = device.orientation == Device.Orientation.Portrait ? "Portrait" : "Landscape"
        cell.OSIcon.image = device.os == Device.OS.iOS ? #imageLiteral(resourceName: "iOS-icon") : #imageLiteral(resourceName: "android-icon")

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
