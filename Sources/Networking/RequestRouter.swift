//
//  RequestRouter.swift
//  
//
//  Created by Amir Daliri on 10.01.2024.
//

import Foundation

public enum RouterType {
    case Driver
    case Passenger
}

public struct RequestRouter {
    
    private static var globalUrl: String? // Make it optional to allow it to be set

    // Set the base URL for the package
    public static func setBaseURL(_ baseURL: String) {
        globalUrl = baseURL
    }

    public static func getUrl(driverEndpoint: DriverEndpoints? = nil, passengerEndpoints: PassengerEndpoints? = nil, type: RouterType) -> String {
        
        guard let globalUrl = globalUrl else {
            fatalError("Base URL not set. Call setBaseURL(_:) to set the base URL before using the router.")
        }        
        
        if type == .Driver {
            guard let driverEndpoint else {
                fatalError("Base URL not set. Call setBaseURL(_:) to set the base URL before using the router.")
            }
            return getDriverEndpoints(driverEndpoint: driverEndpoint, globalUrl: globalUrl)
        } else {
            guard let passengerEndpoints else {
                fatalError("Base URL not set. Call setBaseURL(_:) to set the base URL before using the router.")
            }
            return getPassengerEndpoints(driverEndpoint: passengerEndpoints, globalUrl: globalUrl)
        }
    }
    
    
    private static func getDriverEndpoints(driverEndpoint: DriverEndpoints?, globalUrl: String) -> String {
        switch driverEndpoint {
        case .tokenWithCode:
            return globalUrl + "token/with-code"
        case .login:
            return globalUrl + "token/with-user-data"
        case .signupdriver:
            return globalUrl + "driver"
        case .getlastagreement(let langCode):
            return globalUrl + "contract/latest/\(langCode)/driver"
        case .resetpassword:
            return globalUrl + "driver/"
        case .changepassword:
            return globalUrl + "driver/"
        case .fileupload(let userid), .driver(let userid):
            return globalUrl + "driver/\(userid)"
        case .driversetting(let userid):
            return globalUrl + "driversetting/\(userid)"
        case .getsms(let userid):
            return globalUrl + "driver/\(userid)/send-activation/mobile"
        case .testgetsms(let userid):
            return globalUrl + "driver/\(userid)/test-send-activation/mobile"
        case .sendsmscode(let userid, let code):
            return globalUrl + "driver/\(userid)/mobile/\(code)/activation"
        case .sendtoken:
            return globalUrl + "set-user-device"
        case .matchDriverResponse(let id):
            return globalUrl + "travel/\(id)/matching-driver-response"
        case .travelinfo(let travelId):
            return globalUrl + "travel/\(travelId)"
        case .travelCompleted(let id):
            return globalUrl + "travel/\(id)/travel-completed"
        case .travelStart(let id):
            return globalUrl + "travel/\(id)/travel-start"
        case .paymentInfo(let id):
            return globalUrl + "travel/\(id)/payment-info"
        case .cards(let userId):
            return globalUrl + "driver/\(userId)/wallet-cards"
        case .cardDetail(let userId, let cardId), .setCardDefault(let userId, let cardId), .deleteCard(let userId, let cardId):
            return globalUrl + "driver/\(userId)/wallet-cards/\(cardId)"
        case .addCard(let userId):
            return globalUrl + "driver/\(userId)/add-card-to-wallet"
        case .generalsettings:
            return globalUrl + "generalsetting"
        case .mytravel(let startDate, let endDate, let userid, let skip, let limit):
            return globalUrl + "driver/\(userid)/my-travel/\(startDate)/\(endDate)?skip=\(skip)&limit=\(limit)"
        case .travelearnings(let userid, let startDate, let endDate):
            return globalUrl + "driver/\(userid)/my-travel-earnings/\(startDate)/\(endDate)"
        case .getlaststate(let id):
            return globalUrl + "travel/\(id)/get-status"
        case .country:
            return globalUrl + "country"
        case .city(let countryCode):
            return globalUrl + "city?CustomField=CountryCode&CustomValue=\(countryCode)"
        case .town(let cityId):
            return globalUrl + "county?CustomField=CityCode&CustomValue=\(cityId)"
        case .getCountry(let id):
            return globalUrl + "country/\(id)"
        case .getCity(let id):
            return globalUrl + "city/\(id)"
        case .getTown(let id):
            return globalUrl + "county/\(id)"
        case .cancellationreasons(let langId):
            return globalUrl + "generalsetting/cancellation-reasons?lang=\(langId)"
        case .canceltaxi(let id):
            return globalUrl + "travel/\(id)/travel-cancellation"
        case .call(let id):
            return globalUrl + "travel/\(id)/call/driver"
        case .getState(let travelId):
            return globalUrl + "travel/\(travelId)/get-status"
        case .savewirecardpartner(let userid):
            return globalUrl + "driver/wirecard/\(userid)/save-as-subpartner"
        case .findActiveDriverTravelStatus(let id):
            return globalUrl + "travel/\(id)/find-active-driver-travel-status"
        case .none:
            return globalUrl
        }
    }
    
    private static func getPassengerEndpoints(driverEndpoint: PassengerEndpoints, globalUrl: String) -> String {
        switch driverEndpoint {
        case .login:
            return globalUrl + "token/with-user-data"
        case .signupdriver:
            return globalUrl + "driver"
        case .getlastagreement(let langCode):
            return globalUrl + "contract/latest/\(langCode)/driver"
        case .resetpassword:
            return globalUrl + "driver/"
        case .changepassword:
            return globalUrl + "driver/"
        case .fileupload(let userid), .driver(let userid):
            return globalUrl + "driver/\(userid)"
        case .driversetting(let userid):
            return globalUrl + "driversetting/\(userid)"
        case .getsms(let userid):
            return globalUrl + "driver/\(userid)/send-activation/mobile"
        case .testgetsms(let userid):
            return globalUrl + "driver/\(userid)/test-send-activation/mobile"
        case .sendsmscode(let userid, let code):
            return globalUrl + "driver/\(userid)/mobile/\(code)/activation"
        case .sendtoken:
            return globalUrl + "set-user-device"
        case .matchDriverResponse(let id):
            return globalUrl + "travel/\(id)/matching-driver-response"
        case .travelinfo(let travelId):
            return globalUrl + "travel/\(travelId)"
        case .travelCompleted(let id):
            return globalUrl + "travel/\(id)/travel-completed"
        case .travelStart(let id):
            return globalUrl + "travel/\(id)/travel-start"
        case .paymentInfo(let id):
            return globalUrl + "travel/\(id)/payment-info"
        case .cards(let userId):
            return globalUrl + "driver/\(userId)/wallet-cards"
        case .cardDetail(let userId, let cardId), .setCardDefault(let userId, let cardId), .deleteCard(let userId, let cardId):
            return globalUrl + "driver/\(userId)/wallet-cards/\(cardId)"
        case .addCard(let userId):
            return globalUrl + "driver/\(userId)/add-card-to-wallet"
        case .generalsettings:
            return globalUrl + "generalsetting"
        case .mytravel(let startDate, let endDate, let userid, let skip, let limit):
            return globalUrl + "driver/\(userid)/my-travel/\(startDate)/\(endDate)?skip=\(skip)&limit=\(limit)"
        case .travelearnings(let userid, let startDate, let endDate):
            return globalUrl + "driver/\(userid)/my-travel-earnings/\(startDate)/\(endDate)"
        case .getlaststate(let id):
            return globalUrl + "travel/\(id)/get-status"
        case .country:
            return globalUrl + "country"
        case .city(let countryCode):
            return globalUrl + "city?CustomField=CountryCode&CustomValue=\(countryCode)"
        case .town(let cityId):
            return globalUrl + "county?CustomField=CityCode&CustomValue=\(cityId)"
        case .getCountry(let id):
            return globalUrl + "country/\(id)"
        case .getCity(let id):
            return globalUrl + "city/\(id)"
        case .getTown(let id):
            return globalUrl + "county/\(id)"
        case .cancellationreasons(let langId):
            return globalUrl + "generalsetting/cancellation-reasons?lang=\(langId)"
        case .canceltaxi(let id):
            return globalUrl + "travel/\(id)/travel-cancellation"
        case .call(let id):
            return globalUrl + "travel/\(id)/call/driver"
        case .getState(let travelId):
            return globalUrl + "travel/\(travelId)/get-status"
        case .savewirecardpartner(let userid):
            return globalUrl + "driver/wirecard/\(userid)/save-as-subpartner"
        case .findActiveDriverTravelStatus(let id):
            return globalUrl + "travel/\(id)/find-active-driver-travel-status"
        }
    }
}
