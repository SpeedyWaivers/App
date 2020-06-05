//
//  VenuesResponse.swift
//  SpeedyWaivers
//
//  Created by Lahiru Chathuranga on 5/31/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import Foundation

struct FailableDecodable<Base : Decodable> : Decodable {

    let base: Base?

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.base = try? container.decode(Base.self)
    }
}
