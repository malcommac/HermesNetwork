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

public protocol ResponseTimeline: CustomStringConvertible {
	
	/// The time the request was initialized.
	var requestStartTime: CFAbsoluteTime { get }
	
	/// The time the first bytes were received from or sent to the server.
	var initialResponseTime: CFAbsoluteTime { get }
	
	/// The time when the request was completed.
	var requestCompletedTime: CFAbsoluteTime { get }

	/// The time interval in seconds from the time the request started to the initial
	/// response from the server.
	var latency: TimeInterval { get }

	/// The time interval in seconds from the time the request started
	/// to the time the request completed.
	var requestDuration: TimeInterval { get }
	
    /// The time interval in seconds from the time the request started
	/// to the time response serialization completed.
	var totalDuration: TimeInterval { get }
}

extension Timeline: ResponseTimeline {
	
}

public protocol ResponseProtocol {
	
	/// Type of response (success or failure)
	var type: Response.Result { get }
	
	/// Encapsulates the metrics for a session task.
	/// It contains the taskInterval and redirectCount, as well as metrics for each request / response
	/// transaction made during the execution of the task.
	var metrics: ResponseTimeline? { get }
	
	/// Request
	var request: RequestProtocol { get }
	
	/// Return the http url response
	var httpResponse: HTTPURLResponse? { get }
	
	/// Return HTTP status code of the response
	var httpStatusCode: Int? { get }

	/// Return the raw Data instance response of the request
	var data: Data? { get }
	
	/// Attempt to decode Data received from server and return a JSON object.
	/// If it fails it will return an empty JSON object.
	/// Value is stored internally so subsequent calls return cached value.
	///
	/// - Returns: JSON
	func toJSON() -> JSON
	
	/// Attempt to decode Data received from server and return a String object.
	/// If it fails it return `nil`.
	/// Call is not cached but evaluated at each call.
	/// If no encoding is specified, `utf8` is used instead.
	///
	/// - Parameter encoding: encoding of the data
	/// - Returns: String or `nil` if failed
	func toString(_ encoding: String.Encoding?) -> String?
	
}

public class Response: ResponseProtocol {

	/// Type of response
	///
	/// - success: success
	/// - error: error
	public enum Result {
		case success(_: Int)
		case error(_: Int)
		case noResponse
		
		private static let successCodes: Range<Int> = 200..<299
		
		public static func from(response: HTTPURLResponse?) -> Result {
			guard let r = response else {
				return .noResponse
			}
			return (Result.successCodes.contains(r.statusCode) ? .success(r.statusCode) : .error(r.statusCode))
		}
		
		public var code: Int? {
			switch self {
			case .success(let code): 	return code
			case .error(let code):		return code
			case .noResponse:			return nil
			}
		}
	}
	
	/// Type of result
	public let type: Response.Result
	
	/// Status code of the response
	public var httpStatusCode: Int? {
		return self.type.code
	}
	
	/// HTTPURLResponse
	public let httpResponse: HTTPURLResponse?

	/// Raw data of the response
	public var data: Data?
	
	/// Request executed
	public let request: RequestProtocol
	
	/// Metrics of the request/response to make benchmarks
	public var metrics: ResponseTimeline?

	/// Initialize a new response from Alamofire response
	///
	/// - Parameters:
	///   - response: response
	///   - request: request
	public init(afResponse response: DefaultDataResponse, request: RequestProtocol) {
		self.type = Result.from(response: response.response)
		self.httpResponse = response.response
		self.data = response.data
		self.request = request
		self.metrics = response.timeline
	}
	
	public func toJSON() -> JSON {
		return self.cachedJSON
	}
	
	public func toString(_ encoding: String.Encoding? = nil) -> String? {
		guard let d = self.data else { return nil }
		return String(data: d, encoding: encoding ?? .utf8)
	}
	
	private lazy var cachedJSON: JSON = {
		return JSON(data: self.data ?? Data())
	}()
	
}
