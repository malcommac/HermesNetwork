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
import Alamofire
import SwiftyJSON
import Hydra

/// Service is a concrete implementation of the ServiceProtocol
public class Service: ServiceProtocol {

	/// Configuration
	public var configuration: ServiceConfig
	
	/// Session headers
	public var headers: HeadersDict
	
	/// Initialize a new service with given configuration
	///
	/// - Parameter configuration: configuration. If `nil` is passed attempt to load configuration from your app's Info.plist
	public required init(_ configuration: ServiceConfig) {
		self.configuration = configuration
		self.headers = self.configuration.headers // fillup with initial headers
	}
	
	/// Execute a request and return a promise with the response
	///
	/// - Parameters:
	///   - request: request to execute
	///   - retry: retry attempts. If `nil` only one attempt is made. Default value is `nil`.
	/// - Returns: Promise
	/// - Throws: throw an exception if operation cannot be executed
	public func execute(_ request: RequestProtocol, retry: Int?) -> Promise<ResponseProtocol> {
		// Wrap in a promise the request itself
		let op = Promise<ResponseProtocol>(in: request.context ?? .background, token: request.invalidationToken, { (r, rj, s) in
			// Attempt to create the object to perform request
			let dataOperation: DataRequest = try Alamofire.request(request.urlRequest(in: self))
			// Execute operation in Alamofire
			dataOperation.response(completionHandler: { rData in
				// Parse response
				let parsedResponse = Response(afResponse: rData, request: request)
				switch parsedResponse.type {
				case .success: // success
					r(parsedResponse)
				case .error: // failure
					rj(NetworkError.error(parsedResponse))
				case .noResponse:  // no response
					rj(NetworkError.noResponse(parsedResponse))
				}
			})
		})
		guard let retryAttempts = retry else { return op } // single shot
		return op.retry(retryAttempts) // retry n times
	}
	
}
