//
//  HeaderSecretGenerator.swift
//
//
//  Created by Amir Daliri on 13.03.2024.
//

import UIKit
import Network
import CryptoKit
import Foundation
import CoreTelephony
import SystemConfiguration

/// Protocol defining the necessary functionalities for generating secret headers.
public protocol HeaderSecretGeneratorProtocol {
    /// Generates a secret header string with embedded current timestamp and device information.
    /// - Returns: A secret header string hashed using MD5.
    func generateTokenSecret() -> String

    /// Retrieves the device's current IP address.
    /// - Returns: A string representation of the IP address.
    func getIPAddress() -> String

    /// Constructs a user agent string that includes device name, OS version, and network type.
    /// - Returns: A user agent string.
    func getUserAgent() -> String

    /// Fetches a unique identifier for the device.
    /// - Returns: A UUID string representing the device identifier.
    func getUniqueDeviceId() -> String
}


public struct HeaderSecretGenerator: HeaderSecretGeneratorProtocol {
    
    /// Static instance similar to a singleton pattern for struct.
    static let shared = HeaderSecretGenerator()
    
    /// The secret token string used as the base for generating header secrets.
    private let tokenSecret: String = "@D9Y@Ypu$@F39a@MaW*9@HvK"
    
    /// Generates a secret header string with current timestamp and device information.
    /// - Returns: A secret header string, MD5 hashed and uppercased.
    public func generateTokenSecret() -> String {
        
        var generatedTokenSecret = tokenSecret
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        let currentDate = Date()
        
        formatter.dateFormat = "yyyy"
        let year = formatter.string(from: currentDate)
        generatedTokenSecret = generatedTokenSecret.replacingOccurrences(of: "@Y", with: "\(year)")
        
        formatter.dateFormat = "MM"
        let month = formatter.string(from: currentDate)
        print(month)
        generatedTokenSecret = generatedTokenSecret.replacingOccurrences(of: "@M", with: month)
        
        formatter.dateFormat = "dd"
        let day = formatter.string(from: currentDate)
        generatedTokenSecret = generatedTokenSecret.replacingOccurrences(of: "@D", with: "\(day)")
        
        formatter.dateFormat = "HH"
        let hour = formatter.string(from: currentDate)
        generatedTokenSecret = generatedTokenSecret.replacingOccurrences(of: "@H", with: "\(hour)")
        
        formatter.dateFormat = "mm"
        let minute = formatter.string(from: currentDate)
        generatedTokenSecret = generatedTokenSecret.replacingOccurrences(of: "@F", with: "\(minute)")
        
        // Convert generatedTokenSecret to MD5 hash
        let hashedToken = createMD5Hash(generatedTokenSecret)
        
        return hashedToken.uppercased()
        
    }
    
    /// Retrieves the current IP address of the device.
    /// - Returns: The device's IP address in string format, or an empty string if not found.
    public func getIPAddress() -> String {
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next }
                
                guard let interface = ptr?.pointee else { return "" }
                let addrFamily = interface.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    // wifi = ["en0"]
                    // wired = ["en2", "en3", "en4"]
                    // cellular = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
                    
                    let name: String = String(cString: (interface.ifa_name))
                    if  name == "en0" || name == "en2" || name == "en3" || name == "en4" || name == "pdp_ip0" || name == "pdp_ip1" || name == "pdp_ip2" || name == "pdp_ip3" {
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface.ifa_addr, socklen_t((interface.ifa_addr.pointee.sa_len)), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                    }
                }
            }
            freeifaddrs(ifaddr)
        }
        return address ?? ""
    }
    
    /// Constructs a user agent string from the device's name, OS version, and network connection type.
    /// - Returns: A detailed user agent string.
    public func getUserAgent() -> String {
        let name = Device.current.name ?? ""
        let iOS = (Device.current.systemName ?? "") + " " + (Device.current.systemVersion ?? "")
        let network = "NetworkType: " + getConnectionType()
        
        return name + ", " + iOS + ", " + network
    }
    
    /// Fetches the device's unique identifier.
    /// - Returns: A string containing the UUID of the device or "null" if unavailable.
    public func getUniqueDeviceId() -> String {
        UIDevice.current.identifierForVendor?.uuidString ?? "null"
    }
    
    /// Determines the device's current network connection type.
    /// This method is now private and not part of the protocol.
    /// - Returns: A string indicating the type of network connection (e.g., "NO INTERNET", "WIFI").
    private func getConnectionType() -> String {
        guard let reachability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.google.com") else {
            return "NO INTERNET"
        }
        
        var flags = SCNetworkReachabilityFlags()
        SCNetworkReachabilityGetFlags(reachability, &flags)
        
        let isReachable = flags.contains(.reachable)
        let isWWAN = flags.contains(.isWWAN)
        
        if isReachable {
            if isWWAN {
                let networkInfo = CTTelephonyNetworkInfo()
                let carrierType = networkInfo.serviceCurrentRadioAccessTechnology
                
                guard let carrierTypeName = carrierType?.first?.value else {
                    return "UNKNOWN"
                }
                
                switch carrierTypeName {
                case CTRadioAccessTechnologyGPRS, CTRadioAccessTechnologyEdge, CTRadioAccessTechnologyCDMA1x:
                    return "2G"
                case CTRadioAccessTechnologyLTE:
                    return "4G"
                default:
                    return "3G"
                }
            } else {
                return "WIFI"
            }
        } else {
            return "NO INTERNET"
        }

    }
    
    /// Generates an MD5 hash from a given string.
    /// - Parameter value: The string to hash.
    /// - Returns: An MD5 hash of the input string.
    private func createMD5Hash(_ value: String) -> String {
        guard let data = value.data(using: .utf8) else { return "" }
        let hash = Insecure.MD5.hash(data: data)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }
}
