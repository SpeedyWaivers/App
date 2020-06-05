//
// CustomerRequest.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct CustomerRequest: Codable {

    public var venueId: Int
    public var birthDate: Date?
    public var firstName: String?
    public var lastName: String?
    public var emailAddress: String?
    public var address1: String?
    public var address2: String?
    public var city: String?
    public var state: String?
    public var zip: String?
    public var mobileNumber: String?
    public var signature: String?

    public init(venueId: Int, birthDate: Date?, firstName: String?, lastName: String?, emailAddress: String?, address1: String?, address2: String?, city: String?, state: String?, zip: String?, mobileNumber: String?, signature: String?) {
        self.venueId = venueId
        self.birthDate = birthDate
        self.firstName = firstName
        self.lastName = lastName
        self.emailAddress = emailAddress
        self.address1 = address1
        self.address2 = address2
        self.city = city
        self.state = state
        self.zip = zip
        self.mobileNumber = mobileNumber
        self.signature = signature
    }


}

