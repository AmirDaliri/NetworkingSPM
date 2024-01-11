//
//  ServiceProtocol.swift
//  
//
//  Created by Amir Daliri on 10.01.2024.
//

import Combine
import Alamofire
import Foundation

public protocol ServiceProtocol: AnyObject {
    func fetch(_ url: URL, _ method: HTTPMethod, _ parameters: [String: Any]?, _ headers: HTTPHeaders) -> AnyPublisher<Data, Error>
    func fetchObject<T: Codable>(_ url: URL, _ method: HTTPMethod, _ parameters: [String: Any], _ responseModel: T.Type, _ headers: HTTPHeaders) -> AnyPublisher<T, Error>
}
