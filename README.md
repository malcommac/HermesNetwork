# HermesNetwork

HermesNetwork is the concrete implementation of an isolated/testable networking layer written in Swift.

## Architecture Design

Current version is based upon the network architecture design described in:
[**"Network Layers in Swift (Updated)**"](http://danielemargutti.com/2017/09/09/network-layers-in-swift-updated/) by Daniele Margutti.

## Used Libraries

While the theory behind this approach is independent from the tool used, in order to give a complete out-of-box approach I’ve used the following libraries:

* **Networking support**: in this example the Service  implementation uses [Alamofire](https://github.com/Alamofire/Alamofire). Switching to `NSURLSession`  is pretty easy and, in fact, suggested.
* **Async/Promise support**: I love promises (at least until we’ll get something better with Swift 5) because they are clean, simple and offer a strong error handling mechanism.
Our networking layer uses [Hydra](https://github.com/malcommac/Hydra), that recently hits the 1.0 milestone.
* **JSON**: The higher level (near your app) of the architecture offer out-of-box JSON support with `JSONOperation`  class: everything about JSON was offered by [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON), probability the best library for these stuff.


## Installation
You can install Swiftline using CocoaPods, carthage and Swift package manager

### CocoaPods

```
use_frameworks!
pod 'HermesNetwork'
```

### Carthage
```
github 'malcommac/HermesNetwork'
```

### Swift Package Manager
Add swiftline as dependency in your `Package.swift`

```
import PackageDescription

let package = Package(name: "YourPackage",
dependencies: [
.Package(url: "https://github.com/malcommac/HermesNetwork.git", majorVersion: 0),
]
)
```

<a name="requirements" />
