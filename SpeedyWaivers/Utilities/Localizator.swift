//
//  Localizator.swift


import Foundation
import UIKit

public class Localizator {
    fileprivate func NSLocalizedString(_ key: String) -> String {
        return Foundation.NSLocalizedString(key, comment: "")
    }
}

extension String {
   
    // Alert titles
    static let Alert = NSLocalizedString("Alert", comment: "")
    static let Confirmation = NSLocalizedString("Confirmation", comment: "")
    static let Error = NSLocalizedString("Error", comment: "")
    static let Incomplete = NSLocalizedString("Incomplete", comment: "")
    static let Success = NSLocalizedString("Success", comment: "")
    static let Failed = NSLocalizedString("Failed", comment: "")
    static let Oops = NSLocalizedString("Oops", comment: "")
    static let Warning = NSLocalizedString("Warning", comment: "")
    static let ResetEmailSent = NSLocalizedString("A password reset link has been sent. Please check your email.", comment: "")
    static let SomethingWentWrong = NSLocalizedString("Something went wrong.", comment: "")
    
    // Action titles
    static let Ok = NSLocalizedString("OK", comment: "")
    static let Cancel = NSLocalizedString("Cancel", comment: "")
    static let Yes = NSLocalizedString("Yes", comment: "")
    static let No = NSLocalizedString("No", comment: "")
    static let Retry = NSLocalizedString("Retry", comment: "")
    static let GoBack = NSLocalizedString("Go Back", comment: "")
    static let Dismiss = NSLocalizedString("Dismiss", comment: "")
    static let Call = NSLocalizedString("Call", comment: "")
    static let Settings = NSLocalizedString("Settings", comment: "")
    static let Continue = NSLocalizedString("Continue", comment: "")
    static let Create = NSLocalizedString("Create", comment: "")
    static let Add = NSLocalizedString("Add", comment: "")
    static let Update = NSLocalizedString("Update", comment: "")
    static let Delete = NSLocalizedString("Delete", comment: "")
    static let Skip = NSLocalizedString("Skip", comment: "")
    
    // Alert body
    static let emptyUserName = NSLocalizedString("Username can not be empty.", comment: "")
    static let emptyPassword = NSLocalizedString("Password can not be empty.", comment: "")
    
    static let TakePhoto = NSLocalizedString("Take Photo", comment: "")
    static let ChooseFromLibrary = NSLocalizedString("Choose from Library", comment: "")
}

extension UIImage {
    
}

extension UIColor {
    
    static let buttonLightColor = UIColor(red:0.33, green:0.77, blue:0.82, alpha:1)
    static let buttonDarkColor = UIColor(red:0.09, green:0.09, blue:0.09, alpha:1)
    static let viewBorderColor = UIColor(red:0.81, green:0.15, blue:0.12, alpha:1)
    static let backgroundRed = UIColor(red:0.81, green:0.15, blue:0.12, alpha:1)
    
    static let homeVenueBottomGradientLevel = UIColor(red:0.81, green:0.15, blue:0.12, alpha: 0.8)
}
