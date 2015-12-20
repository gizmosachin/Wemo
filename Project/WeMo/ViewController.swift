//
//  ViewController.swift
//  WeMo
//
//  Created by Sachin on 12/17/15.
//  Copyright © 2015 Sachin Patel. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WemoDelegate {
	var tableView: UITableView
	var devices: [WemoDevice]
	
	init() {
		tableView = UITableView()
		devices = [WemoDevice]()
		
		super.init(nibName: nil, bundle: nil)
		commonInit()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func commonInit() {
		Wemo.sharedInstance.delegate = self
		
		tableView.backgroundColor = UIColor(white: 0.964, alpha: 1.0)
		tableView.estimatedRowHeight = 55
		tableView.dataSource = self
		tableView.delegate = self
		tableView.registerClass(WemoDeviceCell.self, forCellReuseIdentifier: "WemoDeviceCell")
		view.addSubview(tableView)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "WeMo Devices"
		reloadDevices()
	}
	
	func reloadDevices() {
		Wemo.sharedInstance.discoverDevices()
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		tableView.frame = view.frame
	}
	
	// MARK: WemoDelegate
	func wemo(core: Wemo, didDiscoverDevice wemoDevice: WemoDevice) {
		dispatch_async(dispatch_get_main_queue()) { () -> Void in
			self.tableView.reloadData()
		}
	}
	
	func wemoDidEndDiscovery(core: Wemo) {}
	
	// MARK: UITableView
	func numberOfSectionsInTableView(table: UITableView) -> Int {
		return 1
	}
	
	func tableView(table: UITableView, numberOfRowsInSection section: Int) -> Int {
		return Wemo.sharedInstance.devices.count
	}
	
	func tableView(table: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		guard let deviceCell = tableView.dequeueReusableCellWithIdentifier("WemoDeviceCell", forIndexPath: indexPath) as? WemoDeviceCell else {
			return UITableViewCell()
		}
		deviceCell.wemoDevice = Wemo.sharedInstance.devices[indexPath.row]
		return deviceCell
	}
	
	func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0.0
	}
	
	func tableView(table: UITableView, viewForFooterInSection section: Int) -> UIView? {
		return UIView()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
}

