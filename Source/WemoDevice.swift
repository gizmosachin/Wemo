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
	var name: String?
	
	override init() {
		ipAddress = ""
		macAddress = ""
		state = .Unknown
		
		super.init()
	}
	
	convenience init(request: WemoScannerRequest) {
		self.init()
		if let ip = request.ipAddress, mac = request.macAddress {
			ipAddress = ip
			macAddress = mac
		}
		updateState(completion: nil)
	}
	
	// MARK: -
	func determinePort(completion: (() -> ())?) {
		let validPorts = [49154, 49152, 49153, 49155]
		for port in validPorts {
			WemoConduit.run("\(ipAddress):\(port)", type: .GetName, completion: {
				response, error in
				if error == nil {
					self.ipAddress = "\(self.ipAddress):\(port)"
					completion?()
				}
			})
		}
	}
	
	func updateName(completion completion: ((String) -> ())?) {
		assert(ipAddress != "")
		WemoConduit.run(ipAddress, type: .GetName, completion: {
			response, error in
			if let responseString = response {
				// Note: this is a terrible, hacky way to parse XML
				let components = responseString.componentsSeparatedByString("<FriendlyName>")
				let inner = components[1].componentsSeparatedByString("</FriendlyName>")
				let name = inner[0].stringByReplacingOccurrencesOfString("&apos;", withString: "'")
				self.name = name
				completion?(name)
			} else {
				completion?("")
			}
		})
	}
	
	func updateState(completion completion: ((WemoState) -> ())?) {
		assert(ipAddress != "")
		WemoConduit.run(ipAddress, type: .GetState, completion: {
			response, error in
			if let responseString = response {
				// Note: this is a terrible, hacky way to parse XML
				let components = responseString.componentsSeparatedByString("<BinaryState>")
				let inner = components[1].componentsSeparatedByString("</BinaryState>")
				self.state = inner[0] == "1" ? .On : .Off
				completion?(self.state)
			} else {
				completion?(.Unknown)
			}
		})
	}
	
	func setState(state: WemoState, completion: ((Bool) -> ())?) {
		assert(ipAddress != "")
		assert(state != .Unknown, "Can't set state to Unknown.")
		let type: WemoConduitRequestType = state == .On ? .SetStateOn : .SetStateOff
		WemoConduit.run(ipAddress, type: type, completion: {
			response, error in
			self.state = state
			completion?(error == nil)
		})
	}
}
