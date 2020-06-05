//
//  LocalUser.swift
//  SpeedyWaivers
//
//  Created by Lahiru Chathuranga on 5/30/20.
//  Copyright © 2020 Lahiru Chathuranga. All rights reserved.
//

import Foundation


public struct LocalUser: Codable {

    public var userId: Int
    public var username: String?
    public var firstName: String?
    public var passwordHash: String?
    public var lastName: String?
    public var token: String?
    public var createdDate: String?

    public init(userId: Int, username: String?, firstName: String?, lastName: String?, token: String?, createdDate: String?, passwordHash: String?) {
        self.userId = userId
        self.username = username
        self.firstName = firstName
        self.lastName = lastName
        self.passwordHash = passwordHash
        self.token = token
        self.createdDate = createdDate
    }
}
//
//"userId": 1,
//   "username": "test",
//   "passwordHash": "test",
//   "firstName": "Justin",
//   "lastName": "Gerber",
//   "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IjEiLCJuYmYiOjE1OTA4MzY4MTAsImV4cCI6MTU5MTQ0MTYxMCwiaWF0IjoxNTkwODM2ODEwfQ.plGB1-bToalrb8183F1qbGoO2ekeizjnPFy9k5v3aow",
//   "createdDate": "2020-01-01T00:00:00"
