//
//  BaseVM.swift
//  SpeedyWaivers
//
//  Created by Lahiru Chathuranga on 5/17/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

class BaseVM: NSObject {
    // MARK: - Variables
    
    var venues = BehaviorRelay<[VenueWithPages]>(value: [])
    var registrationInfo = BehaviorRelay<RegistrationSettingsResponse?>(value: nil)
    var registrationFields = BehaviorRelay<[RegistrationFieldsByPage]>(value: [])
    var registrationArray = BehaviorRelay<[RegistrationSettingNoId]>(value: [])
    var weiverText = BehaviorRelay<String>(value: "")
    var numberOfFieldsPerPage: Int = 0
    var chunkedArraySize: Int = 0
    
    
    func getVenuesNetworkRequest(completion: @escaping completionHandler) {
        
        let url = RestAPI.BaseURL + WebService.getVenues.rawValue
        
        URLDataRequest.init(url: url, header: .UserSession, param: nil).requestData { (response) in
            
            switch response {
            case .Failure(let error, let statusCode):
                completion(false, statusCode, error.localizedDescription)
            case .Invalid(let message, let statusCode):
                completion(false, statusCode, message)
            case .Success(let data, let statusCode):
                
                let decoder = JSONDecoder()
                if let dataJson = try? decoder.decode([VenueWithPages].self, from: data) {
                    self.venues.accept(dataJson)
                    completion(true, statusCode, "Success")
                } else {
                    completion(false, statusCode, "Failed to decode JSON.")
                }
            }
        }
    }
    
    func getRegistrationDetailsNetworkRequest(completion: @escaping completionHandler) {
        
        let url = RestAPI.BaseURL + WebService.getRegistrationSettings.rawValue + "/\(self.venues.value[0].venueId)"
        
        URLDataRequest.init(url: url, header: .UserSession, param: nil).requestData { (response) in
            
            switch response {
            case .Failure(let error, let statusCode):
                completion(false, statusCode, error.localizedDescription)
            case .Invalid(let message, let statusCode):
                completion(false, statusCode, message)
            case .Success(let data, let statusCode):
                
                let decoder = JSONDecoder()
                if let dataJson =  try?  decoder.decode(RegistrationSettingsResponse.self, from: data) {
                    self.registrationInfo.accept(dataJson)
                    self.weiverText.accept(dataJson.waiverText ?? "")
                    let settings = self.registrationInfo.value?.settings
                    if let index = settings?.firstIndex(where: { (setting) -> Bool in
                        setting.settingName == "NumberOfFieldsPerScreen"
                    }) {
                        self.numberOfFieldsPerPage = Int(settings?[index].settingValue ?? "") ?? 0
                        self.seperateToPages()
                    }
                    completion(true, statusCode, "Success")
                } else {
                    completion(false, statusCode, "Failed to decode JSON.")
                }
            }
        }
    }
    
    func seperateToPages() {
        var fieldsArray: [RegistrationFieldsByPage] = []
        if let chuncked = registrationInfo.value?.registrationFields?.filter({$0.show == true}).chunked(into: numberOfFieldsPerPage) {
            self.chunkedArraySize  = chuncked.count
            for value in 0..<chuncked.count {
                let obj = RegistrationFieldsByPage(page: value, registrationFields: chuncked[value] )
                fieldsArray.append(obj)
            }
        }
        
        
        registrationFields.accept(fieldsArray)
        print(registrationFields.value)
    }
    
    func customerCreateNetworkRequest(params: [String: Any], completion: @escaping completionHandler) {
        let url = RestAPI.BaseURL + WebService.customers.rawValue
        print("UUURRLL \(url)")
        
        URLDataRequest.init(url: url, header: .UserSessionUTF, param: params, method: .post, encoding: JSONEncoding.default).requestData { response in
            
            switch response {
                
            case .Failure(let error, let statusCode):
                completion(false, statusCode, error.localizedDescription)
            case .Invalid(let message, let statusCode):
                completion(false, statusCode, message)
            case .Success(let data, let statusCode):
                completion(true, statusCode, .Success)
            }
        }
    }
}
