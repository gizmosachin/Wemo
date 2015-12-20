//
//  WemoScannerRequest.swift
//  WeMo
//
//  Created by Sachin on 12/17/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

import UIKit

protocol WemoScannerRequestDelegate {
	func wemoScannerRequestLookupDidSucceed(request: WemoScannerRequest)
	func wemoScannerRequestLookupDidFail(request: WemoScannerRequest)
}

class WemoScannerRequest: NSObject, SimplePingDelegate {
	var delegate: WemoScannerRequestDelegate?
	
	private var validationPing: SimplePing?
	var ipAddress: String?
	var macAddress: String?
	
	override init() {
		super.init()
	}
	
	convenience init(ipAddress: String) {
		self.init()
		self.ipAddress = ipAddress
	}
	
	func start() {
		assert(ipAddress != nil, "IP address must be non-nil.")
		validationPing = SimplePing(hostName: ipAddress)
		validationPing?.delegate = self
		validationPing?.start()
		performSelector("timeout", withObject: nil, afterDelay: 1)
	}
	
	func timeout() {
		delegate?.wemoScannerRequestLookupDidFail(self)
	}
	
	// MARK: - SimplePing Delegate
	func simplePing(pinger: SimplePing!, didStartWithAddress address: NSData!) {
		pinger.sendPingWithData(nil)
	}
	
	func simplePing(pinger: SimplePing!, didFailWithError error: NSError!) {
		// Validation failed, device with IP doesn't exist
		delegate?.wemoScannerRequestLookupDidFail(self)
	}
	
	func simplePing(pinger: SimplePing!, didFailToSendPacket packet: NSData!, error: NSError!) {
		// Not connected to network
		delegate?.wemoScannerRequestLookupDidFail(self)
	}
	
	func simplePing(pinger: SimplePing!, didReceivePingResponsePacket packet: NSData!) {
		macAddress = MacAddressHelper.macAddressForIPAddress(ipAddress!)
		delegate?.wemoScannerRequestLookupDidSucceed(self)
	}
}
