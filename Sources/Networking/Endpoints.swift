//
//  Endpoints.swift
//  
//
//  Created by Amir Daliri on 10.01.2024.
//

import Foundation

public enum DriverEndpoints {
    case tokenWithCode
    case login
    case signupdriver
    case getlastagreement(String)
    case resetpassword
    case changepassword
    case fileupload(String)
    case driversetting(String)
    case driver(String)
    case getsms(String)
    case sendsmscode(String, String)
    case testgetsms(String)
    case sendtoken
    case matchDriverResponse(String)
    case travelinfo(String)
    case travelCompleted(String)
    case travelStart(String)
    case paymentInfo(String)
    case cards(String)
    case cardDetail(String, String)
    case addCard(String)
    case setCardDefault(String, String)
    case deleteCard(String, String)
    case generalsettings
    case mytravel(startDate: String, endDate: String, String, Int, Int)
    case travelearnings(String, String, String)
    case getlaststate(String)
    case country 
    case city(String) 
    case town(String)
    case getCountry(String)
    case getCity(String)
    case getTown(String)
    case cancellationreasons(Int)
    case canceltaxi(String)
    case call(String)
    case getState(String)
    case savewirecardpartner(String)
    case findActiveDriverTravelStatus(String)
}

public enum PassengerEndpoints {
    case login
    case signupdriver
    case getlastagreement(String)
    case resetpassword
    case changepassword
    case fileupload(String)
    case driversetting(String)
    case driver(String)
    case getsms(String)
    case sendsmscode(String, String)
    case testgetsms(String)
    case sendtoken
    case matchDriverResponse(String)
    case travelinfo(String)
    case travelCompleted(String)
    case travelStart(String)
    case paymentInfo(String)
    case cards(String)
    case cardDetail(String, String)
    case addCard(String)
    case setCardDefault(String, String)
    case deleteCard(String, String)
    case generalsettings
    case mytravel(startDate: String, endDate: String, String, Int, Int)
    case travelearnings(String, String, String)
    case getlaststate(String)
    case country
    case city(String)
    case town(String)
    case getCountry(String)
    case getCity(String)
    case getTown(String)
    case cancellationreasons(Int)
    case canceltaxi(String)
    case call(String)
    case getState(String)
    case savewirecardpartner(String)
    case findActiveDriverTravelStatus(String)
}

//public enum Endpoints {
//    // Common Endpoints
//    case login
//    case resetpassword
//    case changepassword
//    case sendtoken
//    case generalsettings
//    case country
//    case city
//    case town
//    case getCountry(String)
//    case getCity(String)
//    case getTown(String)
//    case getState(String)
//    case call(String)
//    case canceltaxi(String)
//    case cards(String?)
//    case cardDetail(String, String)
//    case addCard(String?)
//    case setCardDefault(String, String?)
//    case sendsmscode(String, String)
//
//    // Driver Endpoints
//    case tokenWithCode
//    case signupdriver
//    case getlastagreement(String)
//    case fileupload(String)
//    case driversetting(String)
//    case driver(String)
//    case getsms(String)
//    case testgetsms(String)
//    case matchDriverResponse(String)
//    case travelinfo(String)
//    case travelCompleted(String)
//    case travelStart(String)
//    case paymentInfo(String)
//    case deleteCard(String, String)
//    case mytravel(startDate: String, endDate: String, String, Int, Int)
//    case travelearnings(String, String, String)
//    case getlaststate(String)
//    case cancellationreasons(Int)
//    case savewirecardpartner(String)
//    case findActiveDriverTravelStatus(String)
//
//    // Passenger Endpoints
//    case signuppassenger
//    case passengersettings(String)
//    case passenger(String)
//    case countrySettings(String, String)
//    case countrysettings
//    case match
//    case travel
//    case deleteCard(String)
//    case addresses
//    case travelScore
//    case deleteaddress(String)
//    case calculate
//    case finddrivers
//    case getsmscode(String)
//    case distance
//    case papara(String)
//    case promotion(String, String)
//    case passengerDebts
//    case payDebt(String)
//    case paymentConfirmation(String, Bool)
//    case cities(String)
//    case cityForCode(String)
//    case findActivePassengerTravelStatus(String)
//}
