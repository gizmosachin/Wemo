//
//  ViewController.swift
//  WeMo
//
//  Created by Sachin on 12/17/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print("Searching for devices...")
		WemoCore.sharedInstance.reloadDevices({
			devices in
			for device in devices {
				device.setState(.Off, completion: nil)
				print("IP: \(device.ipAddress), MAC: \(device.macAddress)")
			}
		})
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

