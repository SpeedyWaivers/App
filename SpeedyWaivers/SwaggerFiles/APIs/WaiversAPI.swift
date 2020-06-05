//
// WaiversAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class WaiversAPI {
    /**

     - parameter waiverDTO: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func waiversCreateAdultWaiver(waiverDTO: CreateAdultWaiverDTO, completion: @escaping ((_ data: URL?,_ error: Error?) -> Void)) {
        waiversCreateAdultWaiverWithRequestBuilder(waiverDTO: waiverDTO).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - POST /Waivers/CreateAdultWaiver
     - API Key:
       - type: apiKey Authorization 
       - name: JWT
     - examples: [{contentType=application/json, example=""}]
     
     - parameter waiverDTO: (body)  

     - returns: RequestBuilder<URL> 
     */
    open class func waiversCreateAdultWaiverWithRequestBuilder(waiverDTO: CreateAdultWaiverDTO) -> RequestBuilder<URL> {
        let path = "/Waivers/CreateAdultWaiver"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: waiverDTO)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<URL>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter waiverDTO: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func waiversCreateMinorWaiver(waiverDTO: CreateMinorWaiverDTO, completion: @escaping ((_ data: URL?,_ error: Error?) -> Void)) {
        waiversCreateMinorWaiverWithRequestBuilder(waiverDTO: waiverDTO).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - POST /Waivers/CreateMinorWaiver
     - API Key:
       - type: apiKey Authorization 
       - name: JWT
     - examples: [{contentType=application/json, example=""}]
     
     - parameter waiverDTO: (body)  

     - returns: RequestBuilder<URL> 
     */
    open class func waiversCreateMinorWaiverWithRequestBuilder(waiverDTO: CreateMinorWaiverDTO) -> RequestBuilder<URL> {
        let path = "/Waivers/CreateMinorWaiver"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: waiverDTO)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<URL>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter request: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func waiversCreateWaiver(request: CreateWaiverRequest, completion: @escaping ((_ data: Waiver?,_ error: Error?) -> Void)) {
        waiversCreateWaiverWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - POST /Waivers
     - API Key:
       - type: apiKey Authorization 
       - name: JWT
     - examples: [{contentType=application/json, example={
  "createdDate" : "2000-01-23T04:56:07.000+00:00",
  "waiverText" : "waiverText",
  "venueId" : 6,
  "name" : "name",
  "waiverId" : 0
}}]
     
     - parameter request: (body)  

     - returns: RequestBuilder<Waiver> 
     */
    open class func waiversCreateWaiverWithRequestBuilder(request: CreateWaiverRequest) -> RequestBuilder<Waiver> {
        let path = "/Waivers"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Waiver>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

    /**

     - parameter waiverId: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func waiversDeleteWaiverId(waiverId: Int, completion: @escaping ((_ data: Waiver?,_ error: Error?) -> Void)) {
        waiversDeleteWaiverIdWithRequestBuilder(waiverId: waiverId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - DELETE /Waivers/{waiverId}
     - API Key:
       - type: apiKey Authorization 
       - name: JWT
     - examples: [{contentType=application/json, example={
  "createdDate" : "2000-01-23T04:56:07.000+00:00",
  "waiverText" : "waiverText",
  "venueId" : 6,
  "name" : "name",
  "waiverId" : 0
}}]
     
     - parameter waiverId: (path)  

     - returns: RequestBuilder<Waiver> 
     */
    open class func waiversDeleteWaiverIdWithRequestBuilder(waiverId: Int) -> RequestBuilder<Waiver> {
        var path = "/Waivers/{waiverId}"
        let waiverIdPreEscape = "\(waiverId)"
        let waiverIdPostEscape = waiverIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{waiverId}", with: waiverIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Waiver>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "DELETE", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter venueId: (path)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func waiversGetWaiverTemplates(venueId: Int, completion: @escaping ((_ data: WaiverResponse?,_ error: Error?) -> Void)) {
        waiversGetWaiverTemplatesWithRequestBuilder(venueId: venueId).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - GET /Waivers/{venueId}
     - API Key:
       - type: apiKey Authorization 
       - name: JWT
     - examples: [{contentType=application/json, example={
  "selectedWaiver" : {
    "createdDate" : "2000-01-23T04:56:07.000+00:00",
    "waiverText" : "waiverText",
    "venueId" : 6,
    "name" : "name",
    "waiverId" : 0
  },
  "waivers" : [ {
    "createdDate" : "2000-01-23T04:56:07.000+00:00",
    "waiverText" : "waiverText",
    "venueId" : 6,
    "name" : "name",
    "waiverId" : 0
  }, {
    "createdDate" : "2000-01-23T04:56:07.000+00:00",
    "waiverText" : "waiverText",
    "venueId" : 6,
    "name" : "name",
    "waiverId" : 0
  } ]
}}]
     
     - parameter venueId: (path)  

     - returns: RequestBuilder<WaiverResponse> 
     */
    open class func waiversGetWaiverTemplatesWithRequestBuilder(venueId: Int) -> RequestBuilder<WaiverResponse> {
        var path = "/Waivers/{venueId}"
        let venueIdPreEscape = "\(venueId)"
        let venueIdPostEscape = venueIdPreEscape.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        path = path.replacingOccurrences(of: "{venueId}", with: venueIdPostEscape, options: .literal, range: nil)
        let URLString = SwaggerClientAPI.basePath + path
        let parameters: [String:Any]? = nil
        
        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<WaiverResponse>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "GET", URLString: (url?.string ?? URLString), parameters: parameters, isBody: false)
    }

    /**

     - parameter request: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func waiversUpdateWaiver(request: UpdateWaiverRequest, completion: @escaping ((_ data: Waiver?,_ error: Error?) -> Void)) {
        waiversUpdateWaiverWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - POST /Waivers/Update
     - API Key:
       - type: apiKey Authorization 
       - name: JWT
     - examples: [{contentType=application/json, example={
  "createdDate" : "2000-01-23T04:56:07.000+00:00",
  "waiverText" : "waiverText",
  "venueId" : 6,
  "name" : "name",
  "waiverId" : 0
}}]
     
     - parameter request: (body)  

     - returns: RequestBuilder<Waiver> 
     */
    open class func waiversUpdateWaiverWithRequestBuilder(request: UpdateWaiverRequest) -> RequestBuilder<Waiver> {
        let path = "/Waivers/Update"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Waiver>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}