//
//  ApiRequest.swift
//
//  Created by Amir Daliri on 10.01.2024.
//

import Combine
import Alamofire
import Foundation

/// A class responsible for making API requests using Alamofire and Combine.
public class ApiRequest: ServiceProtocol {
    
    private let session: Session
    private let reachabilityManager: NetworkReachabilityManager?
    
    /// Initializes an instance of ApiRequest.
    /// - Parameters:
    ///   - session: The Alamofire Session used for making requests.
    ///   - reachabilityManager: An optional NetworkReachabilityManager for checking network connectivity.
    public init(session: Session = .default, reachabilityManager: NetworkReachabilityManager? = NetworkReachabilityManager()) {
        self.session = session
        self.reachabilityManager = reachabilityManager
    }
    
    /// Fetches data from the specified URL using a given HTTP method.
    /// - Parameters:
    ///   - url: The URL to fetch data from.
    ///   - method: The HTTP method to use for the request.
    ///   - parameters: Optional parameters to include in the request.
    ///   - headers: Optional HTTP headers to include in the request.
    /// - Returns: A publisher that emits the fetched data or an error.
    public func fetch(_ url: URL, _ method: HTTPMethod, _ parameters: [String: Any]? = nil, _ headers: HTTPHeaders) -> AnyPublisher<Data, Error> {
        guard let reachabilityManager = reachabilityManager, reachabilityManager.isReachable else {
            return Fail(error: URLError(.notConnectedToInternet)).eraseToAnyPublisher()
        }
        
        return session.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .publishData()
            .tryMap { response in
                switch response.result {
                case .success(let data):
                    return data
                case .failure(let error):
                    throw error
                }
            }
            .eraseToAnyPublisher()
    }
    
    
    /// Fetches an object of a specified type from the specified URL using a given HTTP method.
    /// - Parameters:
    ///   - url: The URL to fetch data from.
    ///   - method: The HTTP method to use for the request.
    ///   - parameters: Parameters to include in the request.
    ///   - responseModel: The type of object to decode the response into.
    ///   - headers: Optional HTTP headers to include in the request.
    /// - Returns: A publisher that emits the decoded object or an error.
    public func fetchObject<T: Codable>(_ url: URL, _ method: HTTPMethod, _ parameters: [String: Any]? = nil, _ responseModel: T.Type, _ headers: HTTPHeaders) -> AnyPublisher<T, Error> {
        
        guard let reachabilityManager = reachabilityManager, reachabilityManager.isReachable else {
            return Fail(error: URLError(.notConnectedToInternet)).eraseToAnyPublisher()
        }
        
        return session.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .validate()
            .publishData()
            .tryMap { [weak self] response in
                guard let self = self else {
                    throw CustomError.apiError("ServiceFetcher instance is nil")
                }
                
                // Check if the response indicates unauthorized access
                if response.response?.statusCode == NetworkConstants.unauthorizedCode {
                    throw CustomError.logoutRequired
                }
                
                return try self.handleSuccessResponse(response, for: T.self)
            }
            .eraseToAnyPublisher()
    }
    
    
    private func handleSuccessResponse<T: Codable>(_ response: AFDataResponse<Data>, for type: T.Type) throws -> T {
        let data = try validateDataPresence(response)
        let genericData = try JSONDecoder().decode(ServiceResponse<T>.self, from: data)
        
        if let result = genericData.resultObject, let status = genericData.resultStatus, status {
            return result
        } else if genericData.resultCode == NetworkConstants.contractUpdateCode {
            // Handle the contract update case
            throw CustomError.contractUpdateNeeded
        } else if let msg = genericData.resultMessage {
            // Handle other API-specific error messages
            throw CustomError.apiError(msg)
        } else {
            // Handle generic API error
            throw CustomError.apiError("An unknown error occurred")
        }
    }
    
    private func validateDataPresence(_ response: AFDataResponse<Data>) throws -> Data {
        guard let data = response.data else {
            throw AFError.responseValidationFailed(reason: .dataFileNil)
        }
        return data
    }
    
}
