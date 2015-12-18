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
	var networkDevice: WemoNetworkDevice?
	var state: WemoState
	var friendlyName: String?
	
	override init() {
		state = .Unknown
		
		super.init()
		commonInit()
	}
	
	convenience init(networkDevice: WemoNetworkDevice) {
		self.init()
		self.networkDevice = networkDevice
		commonInit()
		updateState(completion: nil)
	}
	
	func commonInit() {
		
	}
	
	func updateState(completion completion: ((WemoState) -> ())?) {
		assert(networkDevice != nil)
	}
	
	func setState(state: WemoState, completion: (Bool) -> ()) {
		assert(networkDevice != nil)
		assert(state != .Unknown, "Can't set state to Unknown.")
	}
}
