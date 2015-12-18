//
//  WemoCore.swift
//  WeMo
//
//  Created by Sachin on 12/17/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

import UIKit

class WemoCore: NSObject, WemoScannerDelegate {
	static let sharedInstance = WemoCore()
	var devices: [WemoDevice]
	
	var reloadDevicesClosure: (([WemoDevice]) -> ())?
	
	override init() {
		devices = [WemoDevice]()
		
		super.init()
		commonInit()
	}
	
	func commonInit() {
		
	}
	
	func reloadDevices(completion: ([WemoDevice]) -> ()) {
		reloadDevicesClosure = completion
		
		let network = WemoScanner()
		network.delegate = self
		network.scan()
	}
	
	// MARK: WemoNetworkDelegate
	func wemoNetworkDidFindDevices(networkDevices: [WemoScannerRequest]) {
		devices = networkDevices.map({ (networkDevice) -> WemoDevice in
			return WemoDevice(networkDevice: networkDevice)
		})
		if let completion = reloadDevicesClosure {
			completion(devices)
			reloadDevicesClosure = nil
		}
	}
}
