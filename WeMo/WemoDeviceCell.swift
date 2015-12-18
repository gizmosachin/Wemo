//
//  WemoDeviceCell.swift
//  WeMo
//
//  Created by Sachin on 12/18/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

import UIKit

class WemoDeviceCell: UITableViewCell {
	var deviceSwitch: UISwitch
	var wemoDevice: WemoDevice {
		didSet {
			self.textLabel?.text = wemoDevice.friendlyName
			wemoDevice.updateState { (state) -> () in
				dispatch_async(dispatch_get_main_queue(), { () -> Void in
					self.deviceSwitch.enabled = state != .Unknown
					self.deviceSwitch.on = state != .Off
				})
			}
		}
	}
	
	override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
		deviceSwitch = UISwitch()
		wemoDevice = WemoDevice()
		
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func commonInit() {
		deviceSwitch.addTarget(self, action: "toggleSwitch", forControlEvents: .ValueChanged)
		contentView.addSubview(deviceSwitch)
	}
	
	func toggleSwitch() {
		if self.deviceSwitch.on {
			wemoDevice.setState(.On, completion: nil)
		} else {
			wemoDevice.setState(.Off, completion: nil)
		}
	}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
	
	override func layoutSubviews() {
		super.layoutSubviews()
		
		deviceSwitch.frame = CGRectMake(frame.width - 60, (frame.height - deviceSwitch.frame.height) / 2.0, deviceSwitch.frame.width, deviceSwitch.frame.height)
	}
}
