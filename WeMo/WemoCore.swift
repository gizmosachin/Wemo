//
//  WemoCore.swift
//  WeMo
//
//  Created by Sachin on 12/17/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

import UIKit

protocol WemoCoreDelegate {
	func wemoCore(core: WemoCore, didDiscoverDevice wemoDevice: WemoDevice)
	func wemoCoreDidEndDiscovery(core: WemoCore)
}

class WemoCore: NSObject, WemoScannerDelegate {
	static let sharedInstance = WemoCore()
	
	var delegate: WemoCoreDelegate?
	var devices: [WemoDevice]
	
	override init() {
		devices = [WemoDevice]()
		
		super.init()
		commonInit()
	}
	
	func commonInit() {
		
	}
	
	func discoverDevices() {
		let network = WemoScanner()
		network.delegate = self
		network.scan()
	}
	
	// MARK: WemoScannerDelegate
	func wemoScannerDidDiscoverDevice(device: WemoDevice) {
		devices.append(device)
		delegate?.wemoCore(self, didDiscoverDevice: device)
	}
	
	func wemoScannerFinishedScanning() {
		
	}
}
