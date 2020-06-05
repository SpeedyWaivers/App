//
//  SettingsVM.swift
//  SpeedyWaivers
//
//  Created by Lahiru Chathuranga on 5/10/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SettingsVM {
    var username = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    
    
    func validateRegistration() throws -> Bool {
        
        guard !(username.value.trim().isEmpty) else {
            throw ValidateError.invalidData(.emptyUserName)
        }
        
        guard !(password.value.trim().isEmpty) else {
            throw ValidateError.invalidData(.emptyPassword)
        }
        
        return true
    }
    
   // Validate and Login
    func validateAndLoginUser(completion: actionHandler) {
        do {
            if try validateRegistration() {
                completion(true, .Success)
            }
        } catch ValidateError.invalidData(let message) {
            completion(false, message)
        } catch {
            completion(false, "Missing Data")
        }
    }
    
    func authenticstionNetworkRequest(completion: @escaping completionHandler) {
        
        let url = RestAPI.BaseURL + WebService.signIn.rawValue
        let param = ["username": username.value, "password": password.value]
        
        URLDataRequest.init(url: url, header: .Guest, param: param, method: .post).requestData { (response) in
            switch response {
            case .Failure(let error, let statusCode):
                completion(false, statusCode, error.localizedDescription)
            case .Invalid(let message, let statusCode):
                completion(false, statusCode, message)
            case .Success(let data, let statusCode):
                
                if let dataString = try? JSONDecoder().decode(LocalUser.self, from: data) {
                    UserDefaults.standard.set(dataString.token ?? "", forKey: "x-access-token")
                    completion(true, statusCode, "success")
                } else {
                    completion(false, statusCode, "Failed to decode JSON.")
                }
            }
        }
    }
}
