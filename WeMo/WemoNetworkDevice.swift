//
//  WemoNetworkDevice.swift
//  WeMo
//
//  Created by Sachin on 12/17/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

import UIKit

protocol WemoNetworkDeviceDelegate {
	func wemoNetworkDeviceLookupDidSucceed(request: WemoNetworkDevice)
	func wemoNetworkDeviceLookupDidFail(request: WemoNetworkDevice)
}

class WemoNetworkDevice: NSObject, SimplePingDelegate {
	var delegate: WemoNetworkDeviceDelegate?
	var baseAddress: String?
	var hostAddress: Int?
	
	private var ping: SimplePing?
	var ipAddress: String?
	var macAddress: String?
	
	override init() {
		super.init()
	}
	
	convenience init(baseAddress: String, hostAddress: Int) {
		self.init()
		self.baseAddress = baseAddress
		self.hostAddress = hostAddress
	}
	
	func start() {
		assert(baseAddress != nil, "Base address must be non-nil.")
		assert(hostAddress != nil, "Host address must be non-nil.")
		let hostName = "\(baseAddress!).\(hostAddress!)"
		ping = SimplePing(hostName: hostName)
		ping?.delegate = self
		ping?.start()
		performSelector("timeout", withObject: nil, afterDelay: 1)
	}
	
	func timeout() {
		delegate?.wemoNetworkDeviceLookupDidFail(self)
	}
	
	// MARK: - SimplePing Delegate
	func simplePing(pinger: SimplePing!, didStartWithAddress address: NSData!) {
		ping?.sendPingWithData(nil)
	}
	
	func simplePing(pinger: SimplePing!, didFailWithError error: NSError!) {
		delegate?.wemoNetworkDeviceLookupDidFail(self)
	}
	
	func simplePing(pinger: SimplePing!, didFailToSendPacket packet: NSData!, error: NSError!) {
		// Not connected to network
		delegate?.wemoNetworkDeviceLookupDidFail(self)
	}
	
	func simplePing(pinger: SimplePing!, didReceivePingResponsePacket packet: NSData!) {
		let originalIP = "\(baseAddress!).\(hostAddress!)"
		let first = originalIP.stringByReplacingOccurrencesOfString(".0", withString: ".")
		let second = first.stringByReplacingOccurrencesOfString(".00", withString: ".")
		ipAddress = second.stringByReplacingOccurrencesOfString("..", withString: ".0.")
		macAddress = MacAddressHelper.macAddressForIPAddress(ipAddress!)
		
		delegate?.wemoNetworkDeviceLookupDidSucceed(self)
	}
}
