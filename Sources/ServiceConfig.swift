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

/// This class is used to configure network connection with a backend server
public final class ServiceConfig: CustomStringConvertible, Equatable {
	
	/// Name of the server configuration. Tipically you can add it your environment name, ie. "Testing" or "Production"
	private(set) var name: String
	
	/// This is the base host url (ie. "http://www.myserver.com/api/v2"
	private(set) var url: URL
	
	/// These are the global headers which must be included in each session of the service
	private(set) var headers: HeadersDict = [:]
	
	/// Cache policy you want apply to each request done with this service
	/// By default is `.useProtocolCachePolicy`.
	public var cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
	
	/// Global timeout for any request. If you want, you can override it in Request
	/// Default value is 15 seconds.
	public var timeout: TimeInterval = 15.0
	
	/// Initialize a new service configuration
	///
	/// - Parameters:
	///   - name: name of the configuration (its just for debug purpose)
	///   - urlString: base url of the service
	///   - api: path to APIs service endpoint
	public init?(name: String? = nil, base urlString: String) {
		guard let url = URL(string: urlString) else { return nil }
		self.url = url
		self.name = name ?? (url.host ?? "")
	}
	
	/// Attempt to load server configuration from Info.plist
	///
	/// - Returns: ServiceConfig if Info.plist of the app can be parsed, `nil` otherwise
	public static func appConfig() -> ServiceConfig? {
		return ServiceConfig()
	}
	
	/// Initialize a new service configuration by looking at paramters
	public convenience init?() {
		// Attemp to load the configuration inside the Info.plist of your app.
		// It must be a dictionary of this type ```{ "endpoint" : { "base" : "host.com", path : "api/v2" } }```
		let appCfg = JSON(Bundle.main.object(forInfoDictionaryKey: Constants.ServerConfig.endpoint.rawValue) as Any)
		guard let base = appCfg[Constants.ServerConfig.base.rawValue].string else {
			return nil
		}
		// Initialize with parameters
		self.init(name: appCfg[Constants.ServerConfig.name.rawValue].stringValue, base: base)
		
		// Attempt to read a fixed list of headers from configuration
		if let fixedHeaders = appCfg[Constants.ServerConfig.headers.rawValue].dictionaryObject as? HeadersDict {
			self.headers = fixedHeaders
		}
	}
	
	/// Readable description
	public var description: String {
		return "\(self.name): \(self.url.absoluteString)"
	}
	
	/// A Service configuration is equal to another if both url and path to APIs endpoint are the same.
	/// This comparison ignore service name.
	///
	/// - Parameters:
	///   - lhs: configuration a
	///   - rhs: configuration b
	/// - Returns: `true` if equals, `false` otherwise
	public static func ==(lhs: ServiceConfig, rhs: ServiceConfig) -> Bool {
		return lhs.url.absoluteString.lowercased() == rhs.url.absoluteString.lowercased()
	}
}
