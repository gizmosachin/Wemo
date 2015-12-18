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
	var state: WemoState
	var friendlyName: String?
	
	override init() {
		state = .Unknown
		
		super.init()
		commonInit()
	}
	
	func commonInit() {
		
	}
}
