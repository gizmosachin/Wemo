# Wemo

Wemo is a set of classes demonstrating how to control [Belkin Wemo light switches](http://www.belkin.com/us/search?q=:sortByProductRank:categoryPath:/Web/WSCH/WSWH/WSWHAS&show=All) in an iOS app.

While it works fairly well, the code is hacky and could break if Belkin changes something via a firmware update, so it should not be used in production apps.

## Usage

To scan the local network for Wemo devices, create a `WemoScanner` and call `scan()`. Implement the delegate method to receive callbacks when devices are discovered and when scanning is complete.

``` swift
let scanner = WemoScanner()
scanner.delegate = self
scanner.scan()
// ...
func wemoScannerDidDiscoverDevice(device: WemoDevice)
func wemoScannerFinishedScanning()
```

Devices discovered by `WemoScanner` will have their `name` property based on the name of the Wemo device that was configured by the user during setup. 

`WemoDevice` has two basic methods to get and set device state.

``` swift
func wemoScannerDidDiscoverDevice(device: WemoDevice) {
  // Update state
  device.updateState (completion: { (state) -> () in
	// ...		
  })
  
  // Turn lights on
  device.setState(.On) { (success) -> () in
  	// ...
  }
  
  // Turn lights off
  device.setState(.Off) { (success) -> () in
  	// ...
  }
}
```

See the included sample project for a demo app that uses these methods.

## How it Works

`WemoScanner` uses files from an Apple sample project called [SimplePing](https://developer.apple.com/library/mac/samplecode/SimplePing/Introduction/Intro.html) to ping all devices on the LAN and then uses a helper class to get the MAC address of each. Belkin Wemo devices *appear* to all use MAC addresses of the form `EC:1A:59:XX:XX:XX`, so a regular expression in `WemoScanner.swift` validates the MAC address and then creates a `WemoDevice` instance with the discovered IP / MAC addresses that is returned to the delegate.

`WemoDevice` stores a Wemo device's IP address, MAC address, and current state, and provides an interface to `WemoConduit` methods that are used for networking. Since Wemo devices use [one of four ports](https://bitbucket.org/jacklawry/wemo/src/cc2016b8718203fc501dbd557c305a4189611713/wemo_control.sh?at=master&fileviewer=file-view-default), there is also an internal method to determine which port the Wemo device is using.

`WemoConduit` sends HTTP POST requests to the device with the headers and body that the device expects in order to execute certain commands.

## References

- [WeMo shell script](https://bitbucket.org/jacklawry/wemo/src/cc2016b8718203fc501dbd557c305a4189611713/wemo_control.sh?at=master&fileviewer=file-view-default)
- [SimplePing](https://developer.apple.com/library/mac/samplecode/SimplePing/Introduction/Intro.html)
- [Getting local IP address](http://stackoverflow.com/questions/25626117/how-to-get-ip-address-in-swift)

## License

Wemo is available under the MIT license, see the [LICENSE](https://github.com/gizmosachin/Wemo/blob/master/LICENSE) file for more information.