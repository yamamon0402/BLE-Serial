//
//  ViewController.swift
//  Client
//
//  Created by 山本　恭大 on 2015/02/16.
//  Copyright (c) 2015年 山本　恭大. All rights reserved.
//

import UIKit

class TopViewController: UIViewController{
    
    @IBOutlet private weak var rightSlider : UISlider!
    @IBOutlet private weak var leftSlider : UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var communicator : BLESerialCommunicator = BLESerialCommunicator.sharedInstance
        communicator.connect()
        
        communicator.readBlock = {string in
            self.dispatch_async_main
                {
                    println(string)
            }
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
    }
    
    deinit
    {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func prev(sender:AnyObject)
    {
        var communicator : BLESerialCommunicator = BLESerialCommunicator.sharedInstance
        communicator.write("a")
    }
    
    @IBAction func back(sender:AnyObject)
    {
        var communicator : BLESerialCommunicator = BLESerialCommunicator.sharedInstance
        communicator.write("z")
    }
    
    @IBAction func rotate(sender:AnyObject)
    {
        var communicator : BLESerialCommunicator = BLESerialCommunicator.sharedInstance
        communicator.write("r")
    }
    
    @IBAction func stop(sender:AnyObject)
    {
        var communicator : BLESerialCommunicator = BLESerialCommunicator.sharedInstance
        communicator.write("o")
    }
    
    // MARK: - Utility -
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
}

