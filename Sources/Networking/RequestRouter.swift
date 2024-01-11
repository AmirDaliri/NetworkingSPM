//
//  RequestRouter.swift
//
//
//  Created by Amir Daliri on 10.01.2024.
//

import Foundation

/// A utility struct for routing requests to specific endpoints.
public struct RequestRouter {
    
    /// The global base URL used for constructing endpoint URLs.
    private static var globalUrl: String?
    
    /// Sets the base URL for the package.
    ///
    /// - Parameter baseURL: The base URL to be used for constructing endpoint URLs.
    public static func setBaseURL(_ baseURL: String) {
        globalUrl = baseURL
    }
    
    /// Retrieves the complete URL for a given endpoint using the global base URL.
    ///
    /// - Parameter endpoint: An instance conforming to the `EndpointProtocol` that defines the endpoint's path.
    /// - Returns: The complete URL constructed by combining the base URL and the endpoint's path.
    /// - Note: Ensure that you have called `setBaseURL(_:)` to set the base URL before using this method.
    ///
    /// Example Usage:
    /// ```
    /// public enum Endpoint: EndpointProtocol {
    ///   case appSetting
    ///   case login
    ///   case register(String)
    ///
    /// public var path: String {
    ///     switch self {
    ///     case .appSetting:
    ///         return "api/v2/appSetting"
    ///     case .login:
    ///         return "api/v2/login"
    ///     case .register(let name):
    ///         return "api/v2/register/\(name)"
    ///     }
    ///   }
    /// }
    /// ```
    public static func getUrl(endpoint: EndpointProtocol) -> String {
        guard let globalUrl = globalUrl else {
            fatalError("Base URL not set. Call setBaseURL(_:) to set the base URL before using the router.")
        }
        return globalUrl + endpoint.path
    }
}
