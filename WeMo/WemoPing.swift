//
//  WemoPing.swift
//  WeMo
//
//  Created by Sachin on 12/17/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

import UIKit

protocol WemoPingDelegate {
	func wemoPingRequestDidSucceed(request: WemoPing)
	func wemoPingRequestDidFail(request: WemoPing)
}

class WemoPing: NSObject, SimplePingDelegate {
	var delegate: WemoPingDelegate?
	var baseAddress: String?
	var hostAddress: Int?
	
	var ipAddress: String?
	private var ping: SimplePing?
	
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
		delegate?.wemoPingRequestDidFail(self)
	}
	
	// MARK: SimplePing Delegate
	func simplePing(pinger: SimplePing!, didStartWithAddress address: NSData!) {
		ping?.sendPingWithData(nil)
	}
	
	func simplePing(pinger: SimplePing!, didFailWithError error: NSError!) {
		delegate?.wemoPingRequestDidFail(self)
	}
	
	func simplePing(pinger: SimplePing!, didFailToSendPacket packet: NSData!, error: NSError!) {
		// Not connected to network
		delegate?.wemoPingRequestDidFail(self)
	}
	
	func simplePing(pinger: SimplePing!, didReceivePingResponsePacket packet: NSData!) {
		let originalIP = "\(baseAddress!).\(hostAddress!)"
		let first = originalIP.stringByReplacingOccurrencesOfString(".0", withString: ".")
		let second = first.stringByReplacingOccurrencesOfString(".00", withString: ".")
		ipAddress = second.stringByReplacingOccurrencesOfString("..", withString: ".0.")
		
		delegate?.wemoPingRequestDidSucceed(self)
	}
}
