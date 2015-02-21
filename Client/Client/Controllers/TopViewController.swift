//
//  ViewController.swift
//  Client
//
//  Created by 山本　恭大 on 2015/02/16.
//  Copyright (c) 2015年 山本　恭大. All rights reserved.
//

import UIKit

class TopViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    @IBOutlet private weak var scanButton : UIButton!
    @IBOutlet private weak var indicator : UIActivityIndicatorView!
    @IBOutlet private weak var tableView : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var manager:BLEManager = BLEManager.sharedInstance
        
        manager.discoverBlock = {
            self.dispatch_async_main{
                self.tableView.reloadData()
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidDisappear(animated: Bool) {
        var manager:BLEManager = BLEManager.sharedInstance
        manager.stopScan()
        scanButton.setTitle("START", forState: UIControlState.Normal)
        indicator.stopAnimating()
    }
    
    deinit
    {
        var manager:BLEManager = BLEManager.sharedInstance
        manager.stopScan()
        scanButton.setTitle("START", forState: UIControlState.Normal)
        indicator.stopAnimating()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func toggleScan(sender:AnyObject)
    {
        var manager:BLEManager = BLEManager.sharedInstance
        if manager.isScannning == false
        {
            if manager.scanDevices("") == true
            {
                scanButton.setTitle("STOP", forState: UIControlState.Normal)
                indicator.startAnimating()
            }
        }
        else
        {
            manager.stopScan()
            scanButton.setTitle("START", forState: UIControlState.Normal)
            indicator.stopAnimating()
        }
        tableView.reloadData()
        NSLog("%d",manager.isScannning)
    }
    
    // MARK: - tableViewDataSource -
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var tableViewCell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("CELL", forIndexPath: indexPath) as UITableViewCell
        
        var manager:BLEManager = BLEManager.sharedInstance
        var device : BLEDevice = manager.devices[indexPath.row] as BLEDevice
        tableViewCell.textLabel?.text = device.localName
        
        return tableViewCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var manager:BLEManager = BLEManager.sharedInstance
        println("\(manager.devices.count)")
        return manager.devices.count
    }
    
    // MARK: - TableViewDelegate -
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
    }
    
    
    // MARK: - Utility -
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
}

