//
// Setting.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct Setting: Codable {

    public var settingId: Int
    public var venueId: Int
    public var settingName: String?
    public var settingValue: String?
    public var createdDate: String?

    public init(settingId: Int, venueId: Int, settingName: String?, settingValue: String?, createdDate: String?) {
        self.settingId = settingId
        self.venueId = venueId
        self.settingName = settingName
        self.settingValue = settingValue
        self.createdDate = createdDate
    }


}

