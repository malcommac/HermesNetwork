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
import Hydra
import SwiftyJSON

public class Request: RequestProtocol {
	public var context: Context?
	
	/// Invalidation token to cancel the request
	public var invalidationToken: InvalidationToken?
	
	/// Endpoint for request
	public var endpoint: String
	
	/// Body of the request
	public var body: RequestBody?
	
	/// HTTP method of the request
	public var method: RequestMethod?
	
	/// Fields of the request
	public var fields: ParametersDict?
	
	/// URL of the request
	public var urlParams: ParametersDict?
	
	/// Headers of the request
	public var headers: HeadersDict?
	
	/// Cache policy
	public var cachePolicy: URLRequest.CachePolicy?
	
	/// Timeout of the request
	public var timeout: TimeInterval?
	
	/// Initialize a new request
	///
	/// - Parameters:
	///   - method: HTTP Method request (if not specified, `.get` is used)
	///   - endpoint: endpoint of the request
	///   - params: paramters to replace in endpoint
	///   - fields: fields to append inside the url
	///   - body: body to set
	public init(method: RequestMethod = .get, endpoint: String = "", params: ParametersDict? = nil, fields: ParametersDict? = nil, body: RequestBody? = nil) {
		self.method = method
		self.endpoint = endpoint
		self.urlParams = params
		self.fields = fields
		self.body = body
	}
}
