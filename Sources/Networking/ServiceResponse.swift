//
//  ServiceResponse.swift
//
//
//  Created by Amir Daliri on 10.01.2024.
//

import Foundation

public struct ServiceResponse<T: Codable>: Codable {
    let version: String?
    let resultStatus: Bool?
    let resultCode: Int?
    let resultMessage: String?
    let resultObject: T?
}
