//
//	HermesNetwork
//  Networking Layer in Swift
//
//  Original article:		http://danielemargutti.com/2017/09/09/network-layers-in-swift-updated/
//	Created by:				Daniele Margutti
//
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in
//	all copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//	THE SOFTWARE.

import Foundation
import SwiftyJSON
import Alamofire
import Hydra

public protocol ServiceProtocol {
	
	/// This is the configuration used by the service
	var configuration: ServiceConfig { get }
	
	/// Headers used by the service. These headers are mirrored automatically
	/// to any Request made using the service. You can replace or remove it
	/// by overriding the `willPerform()` func of the `Request`.
	/// Session headers initially also contains global headers set by related server configuration.
	var headers: HeadersDict { get }
	
	/// Initialize a new service with specified configuration
	///
	/// - Parameter configuration: configuration to use
	init(_ configuration: ServiceConfig)

	/// Execute a request and return a promise with a response
	///
	/// - Parameter request: request to execute
	/// - Returns: Promise with response
	func execute(_ request: RequestProtocol, retry: Int?) -> Promise<ResponseProtocol>

}
