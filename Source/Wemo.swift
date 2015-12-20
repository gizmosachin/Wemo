//
//  Wemo.swift
//  WeMo
//
//  Created by Sachin on 12/17/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

import UIKit

protocol WemoDelegate {
	func wemo(controller: Wemo, didDiscoverDevice wemoDevice: WemoDevice)
	func wemoDidEndDiscovery(core: Wemo)
}

class Wemo: NSObject, WemoScannerDelegate {
	static let sharedInstance = Wemo()
	
	var delegate: WemoDelegate?
	var devices: [WemoDevice]
	
	override init() {
		devices = [WemoDevice]()
		
		super.init()
	}
	
	func discoverDevices() {
		devices.removeAll()
		let network = WemoScanner()
		network.delegate = self
		network.scan()
	}
	
	// MARK: WemoScannerDelegate
	func wemoScannerDidDiscoverDevice(device: WemoDevice) {
		devices.append(device)
		delegate?.wemo(self, didDiscoverDevice: device)
	}
	
	func wemoScannerFinishedScanning() {
		delegate?.wemoDidEndDiscovery(self)
	}
}
