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

public class HeaderSecretGenerator {
    
    /// Singleton instance for `HeaderSecretGenerator`.
    static let shared = HeaderSecretGenerator.init()
    /// The secret token string used for generating header secrets.
    private let tokenSecret: String
    
    /// Initializes a new instance of `HeaderSecretGenerator`.
    init() {
        self.tokenSecret = "@D9Y@Ypu$@F39a@MaW*9@HvK"
    }

    /// Generates a secret header with timestamp and device information.
    ///
    /// - Returns: A secret header string.
    func generateTokenSecret() -> String {
        var generatedTokenSecret = tokenSecret
        
        let formatter = DateFormatter()
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
        formatter.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone?
        let hour = formatter.string(from: currentDate)
        generatedTokenSecret = generatedTokenSecret.replacingOccurrences(of: "@H", with: "\(hour)")
        
        
        formatter.dateFormat = "mm"
        let minute = formatter.string(from: currentDate)
        generatedTokenSecret = generatedTokenSecret.replacingOccurrences(of: "@F", with: "\(minute)")
        print("before hash", generatedTokenSecret)
        // Convert generatedTokenSecret to MD5 hash
        
        let hashedToken = createMD5Hash(generatedTokenSecret)
        print("after hash", hashedToken.uppercased())
        return hashedToken.uppercased()
    }

    /// Creates an MD5 hash from the given value.
    ///
    /// - Parameter value: The string value to hash.
    /// - Returns: The MD5 hash string.
    private func createMD5Hash(_ value: String) -> String {
        guard let data = value.data(using: .utf8) else { return "" }
        let hash = Insecure.MD5.hash(data: data)
        return hash.map { String(format: "%02hhx", $0) }.joined()
    }

    
    /// Gets the IP address of the device.
    ///
    /// - Returns: The IP address string.
    func getIPAddress() -> String {
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
    
    /// Gets the user agent string of the device.
    ///
    /// - Returns: The user agent string.
    func getUserAgent() -> String {
        let name = Device.current.name ?? ""
        let iOS = (Device.current.systemName ?? "") + " " + (Device.current.systemVersion ?? "")
        let network = "NetworkType: " + HeaderSecretGenerator.getConnectionType()
        
        return name + ", " + iOS + ", " + network
    }
    
    /// Gets the unique device identifier.
    ///
    /// - Returns: The unique device identifier string.
    func getUniqueDeviceId() -> String {
        return UIDevice.current.identifierForVendor?.uuidString ?? "null"
    }
}

// MARK: - Connection Type Method
extension HeaderSecretGenerator {
    /// Gets the type of network connection.
    ///
    /// - Returns: The type of network connection.
    class func getConnectionType() -> String {
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
}
