//
//  ApplicationService.swift
//  SpeedyWaivers
//
//  Created by Lahiru Chathuranga on 5/30/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import Foundation
import UIKit

class ApplicationService {
    
    static let shared = ApplicationService()
    
    
    func manageUserDirection() {
        if UserDefaults.standard.string(forKey: "x-access-token") != nil {
            let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
            let vc = sb.instantiateViewController(withIdentifier: "LandingVC") as! LandingVC
            vc.isUser = true
            UIApplication.shared.keyWindow?.rootViewController = vc
            
        } else {
           let sb = UIStoryboard(name: "Main", bundle: Bundle.main)
           let vc = sb.instantiateViewController(withIdentifier: "LandingVC") as! LandingVC
           vc.isUser = false
           UIApplication.shared.keyWindow?.rootViewController = vc
        }
    }
}
