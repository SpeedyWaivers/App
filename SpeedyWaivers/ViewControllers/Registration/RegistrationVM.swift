//
//  RegistrationVM.swift
//  SpeedyWaivers
//
//  Created by Lahiru Chathuranga on 5/10/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class RegistrationVM: BaseVM {
    
}
struct RegistrationFieldsByPage {
    var page: Int
    var registrationFields: [RegistrationSettingNoId]
    
    init(page: Int, registrationFields: [RegistrationSettingNoId]) {
        self.page = page
        self.registrationFields = registrationFields
    }
}


