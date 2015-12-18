//
//  WemoConduit.swift
//  WeMo
//
//  Created by Sachin on 12/18/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

import UIKit

enum WemoConduitRequestType {
	case GetState
	case GetSignalStrength
	case GetFriendlyName
	case SetStateOn
	case SetStateOff
}

class WemoConduit: NSObject {
	static let sharedInstance = WemoConduit()

	private func actionStringForRequestType(type: WemoConduitRequestType) -> String {
		switch type {
		case .GetState:
			return "GetBinaryState"
		case .GetSignalStrength:
			return "GetSignalStrength"
		case .GetFriendlyName:
			return "GetFriendlyName"
		case .SetStateOff, .SetStateOn:
			return "SetBinaryState"
		}
	}
	
	func run(ipAddress: String, type: WemoConduitRequestType) {
		let actionString = actionStringForRequestType(type)
		
		// Set up request
		let port = "49153"
		let url = NSURL(string: "http://\(ipAddress):\(port)/upnp/control/basicevent1")!
		let session = NSURLSession.sharedSession()
		let request = NSMutableURLRequest(URL: url)
		request.HTTPMethod = "POST"
		request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
		
		// Set headers
		request.setValue("text/xml", forHTTPHeaderField: "Content-Type")
		request.addValue("\"urn:Belkin:service:basicevent:1#\(actionString)\"", forHTTPHeaderField: "SOAPACTION")
		
		// Determine body to send
		var parameterValueString = ""
		switch type {
			case .SetStateOn, .GetState: parameterValueString = "1"
			case .SetStateOff, .GetSignalStrength: parameterValueString = "0"
			default: parameterValueString = ""
		}
		let parameterKey = actionString.stringByReplacingOccurrencesOfString("Get", withString: "").stringByReplacingOccurrencesOfString("Set", withString: "")
		let dataString = "<?xml version=\"1.0\" encoding=\"utf-8\"?><s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><s:Body><u:\(actionString) xmlns:u=\"urn:Belkin:service:basicevent:1\"><\(parameterKey)>\(parameterValueString)</\(parameterKey)></u:\(actionString)></s:Body></s:Envelope>"
		request.HTTPBody = dataString.dataUsingEncoding(NSUTF8StringEncoding)
		
		// Perform request
		let task = session.dataTaskWithRequest(request) {
			(let data, let response, let error) in
			
			guard let _:NSData = data, let _:NSURLResponse = response  where error == nil else {
				print("error")
				return
			}
			
			let dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)
			print(dataString)
		}
		
		task.resume()
	}
}
