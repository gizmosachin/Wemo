//
//  WemoDevice.swift
//  WeMo
//
//  Created by Sachin on 12/17/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

import UIKit

enum WemoState {
	case On
	case Off
	case Unknown
}

class WemoDevice: NSObject {
	var ipAddress: String
	var macAddress: String
	var state: WemoState
	var friendlyName: String?
	
	override init() {
		ipAddress = ""
		macAddress = ""
		state = .Unknown
		
		super.init()
		commonInit()
	}
	
	convenience init(networkDevice: WemoScannerRequest) {
		self.init()
		if let ip = networkDevice.ipAddress, mac = networkDevice.macAddress {
			self.ipAddress = ip
			self.macAddress = mac
		}
		commonInit()
		updateState(completion: nil)
	}
	
	func commonInit() {
		
	}
	
	func updateState(completion completion: ((WemoState) -> ())?) {
		assert(ipAddress != "")
	}
	
	func setState(state: WemoState, completion: (Bool) -> ()) {
		assert(ipAddress != "")
		assert(state != .Unknown, "Can't set state to Unknown.")
	}
}
