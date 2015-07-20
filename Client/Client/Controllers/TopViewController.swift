//
//  ViewController.swift
//  Client
//
//  Created by 山本　恭大 on 2015/02/16.
//  Copyright (c) 2015年 山本　恭大. All rights reserved.
//

import UIKit

class TopViewController: UIViewController{
    
    @IBOutlet private weak var countText: UILabel!
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        var communicator : BLESerialCommunicator = BLESerialCommunicator.sharedInstance
        
        
        communicator.readBlock = {string in
            self.dispatch_async_main
                {
                    self.counter = self.counter + 1
                    self.countText.text = "\(self.counter)"
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
    
    @IBAction func connect(sender:AnyObject)
    {
        var communicator : BLESerialCommunicator = BLESerialCommunicator.sharedInstance
        communicator.connect()
    }
    
    @IBAction func disconnect(sender:AnyObject)
    {
        var communicator : BLESerialCommunicator = BLESerialCommunicator.sharedInstance
        communicator.disconnect()
    }
    
    @IBAction func send(sender:AnyObject)
    {
        var communicator : BLESerialCommunicator = BLESerialCommunicator.sharedInstance
        communicator.write("aaa")
    }
    
    
    // MARK: - Utility -
    func dispatch_async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue(), block)
    }
}

