//
// CreateAdultWaiverDTO.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation



public struct CreateAdultWaiverDTO: Codable {

    public var signature: Data?
    public var adultCustId: Int

    public init(signature: Data?, adultCustId: Int) {
        self.signature = signature
        self.adultCustId = adultCustId
    }


}

