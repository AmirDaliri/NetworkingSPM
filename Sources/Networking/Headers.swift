//
//  Headers.swift
//  
//
//  Created by Amir Daliri on 10.01.2024.
//

import Alamofire

public struct Headers {
    static func refresh(token: String) -> HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "Authorization": "bearer \(token)"
        ]
    }
    
    public static let withoutToken: HTTPHeaders = ["Content-Type": "application/json"]
    
    public static func withToken(token: String) -> HTTPHeaders {
        return refresh(token: token)
    }
}

extension HTTPHeaders {
    public static let withoutoken: HTTPHeaders = ["Content-Type":"application/json"]
}
