import Foundation
import UIKit

public enum ResponseStatus: String {
    case success
    case error
}

public enum AppEnvironment {
    case development
    case staging
    case production
}

public struct RestAPI {
    
    private static let appEnvironment: AppEnvironment = .development
    static let APIKey = ""
    
    static var BaseURL: String {
        get {
            switch appEnvironment {
            case .development:
                return "https://coreapi.speedywaivers.com"
            case .staging:
                return "https://coreapi.speedywaivers.com"
            case .production:
                return "https://coreapi.speedywaivers.com"
            }
        }
    }
    
    static var APIVersion: String {
        get {
            switch appEnvironment {
            case .development:
                return "/api/v1"
            case .staging:
                return "/api/v1"
            case .production:
                return "/api/v1"
            }
        }
    }
    
    static var googlePlacesKey = ""
    static var googleCloudVisionKey = ""
    
    static var googlePlacesUrl = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&location=%@&radius=10000&key=\(googlePlacesKey)"
    
    static var googleVisionUrl = "https://vision.googleapis.com/v1/images:annotate?key=\(googleCloudVisionKey)"
    
}

public enum WebService: String {
    
    case signIn = "/authenticate"
    case getVenues = "/Venues"
    case getRegistrationSettings = "/RegistrationSettings"
    case customers = "/Customers"
    // Add more cases if needed
}
