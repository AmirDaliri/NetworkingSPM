//
//  Headers.swift
//  
//
//  Created by Amir Daliri on 10.01.2024.
//

import Alamofire

public struct Headers {
    
    // Common headers
    public static func commonHeaders() -> HTTPHeaders {
        return [
            "Content-Type": "application/json",
            "LGKWT": HeaderSecretGenerator.shared.generateTokenSecret(),
            "LUA": HeaderSecretGenerator.shared.getUserAgent(),
            "LUP": HeaderSecretGenerator.shared.getIPAddress(),
            "LUD": HeaderSecretGenerator.shared.getUniqueDeviceId(),
            "LUDT": "IOS"
        ]
    }
    
    // Headers without token
    public static let withoutToken: HTTPHeaders = commonHeaders()
    
    // Headers with token
    public static func withToken(token: String) -> HTTPHeaders {
        var headers = commonHeaders()
        headers["Authorization"] = "bearer \(token)"
        return headers
    }
    
    // Refresh token
    static func refresh(token: String) -> HTTPHeaders {
        var headers = withToken(token: token)
        headers["LGKWT"] = HeaderSecretGenerator.shared.generateTokenSecret()
        return headers
    }
}

extension HTTPHeaders {
    public static let withoutoken: HTTPHeaders = Headers.withoutToken
}
