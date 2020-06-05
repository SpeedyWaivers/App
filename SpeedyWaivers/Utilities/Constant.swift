//
//  Constant.swift

//  Created by Dushan Saputhanthri on 19/3/19.
//  Copyright © 2019 Elegant Media Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

struct Constant {
    
    static let appEnvironment: DeploymentEnvironment = .development
    
    enum DeploymentEnvironment: String {
        case development = "http://medihub-backend.sandbox8.elegant-media.com/api/v1"
        case staging = ""
        case production = "nil"
    }
    
    func getCustomHeaders() -> [String:String] {
        switch Constant.appEnvironment {
        case .development:
            return ["x-api-key": "suYSjwJx9rZ2CimlraJ1hc748G966bOL"]
        case .staging:
            return ["x-api-key": ""]
        case .production:
            return ["x-api-key": ""]
        }
    }
    
    enum APIKeys {
        static let RESTful = "suYSjwJx9rZ2CimlraJ1hc745G966bOL"
        static let googleMap = "AIzaSyAWBpYdXWTp0OzIvSNIB08d3414nYvA3Pc"
    }
    
    enum Counts {
        static let passwordCount = 6
        static let nameMinimumCharCount = 2
    }
    
    enum AppDetails {
        static let termsUrl = "https://www.elegantmedia.com.au/"
        static let privacyUrl = "https://www.elegantmedia.com.au/privacy-policy/"
        static let aboutUrl = "https://www.elegantmedia.com.au/about-us/"
    }
    
    enum ColorSets {
        static let purpleButtonGradient: [UIColor] = [.buttonLightColor, .buttonDarkColor]
    }
    
    enum Notification {
        static let StoppedAtControlCentre = NSNotification.Name(rawValue: "StoppedAtControlCentre")
        static let FavButtonChanged  = NSNotification.Name(rawValue: "FavButtonChanged")
        static let DynamicLinkCatched = NSNotification.Name(rawValue: "DynamicLinkCatched")
        static let PushNotificationMessage = NSNotification.Name(rawValue: "PushNotificationMessage")
        static let PushNotificationMedia = NSNotification.Name(rawValue: "PushNotificationMedia")
        static let ChangedTabBarIndex = NSNotification.Name(rawValue: "ChangedTabBarIndex")
        static let PushNotificationBadgeCountChange = NSNotification.Name(rawValue: "PushNotificationBadgeCountChange")
        static let didReceiveNotification = NSNotification.Name("didReceiveNotification")
    }
}
