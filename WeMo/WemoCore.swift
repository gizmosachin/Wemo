//
//  WemoCore.swift
//  WeMo
//
//  Created by Sachin on 12/17/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

import UIKit

class WemoCore: NSObject {
	static let sharedInstance = WemoCore()
	var devices: [WemoDevice]
	
	override init() {
		devices = [WemoDevice]()
		
		super.init()
		commonInit()
	}
	
	func commonInit() {
		
	}
	
	func scan(completion: ([WemoDevice]) -> ()) {
		
	}
}
