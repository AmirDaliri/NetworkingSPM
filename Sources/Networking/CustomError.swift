//
//  CustomError.swift
//  
//
//  Created by Amir Daliri on 10.01.2024.
//

import Foundation

public enum CustomError: Error {
    case apiError(String)
    case contractUpdateNeeded
    case logoutRequired
}
