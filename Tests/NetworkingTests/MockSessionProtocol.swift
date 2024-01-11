//
//  MockSessionProtocol.swift
//  
//
//  Created by Amir Daliri on 10.01.2024.
//

import Alamofire
import Foundation

class MockSessionProtocol: Session {
    var data: Data?
    var response: AFDataResponse<Data>?
    
    func request(_ convertible: URLRequestConvertible) -> DataRequest {
        fatalError("MockSessionProtocol.request not implemented")
    }
}
