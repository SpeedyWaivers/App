//
// SettingsAPI.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation
import Alamofire



open class SettingsAPI {
    /**

     - parameter request: (body)  
     - parameter completion: completion handler to receive the data and the error objects
     */
    open class func settingsSaveSetting(request: SaveSettingRequest, completion: @escaping ((_ data: Setting?,_ error: Error?) -> Void)) {
        settingsSaveSettingWithRequestBuilder(request: request).execute { (response, error) -> Void in
            completion(response?.body, error)
        }
    }


    /**
     - POST /Settings
     - API Key:
       - type: apiKey Authorization 
       - name: JWT
     - examples: [{contentType=application/json, example={
  "createdDate" : "2000-01-23T04:56:07.000+00:00",
  "settingValue" : "settingValue",
  "venueId" : 6,
  "settingId" : 0,
  "settingName" : "settingName"
}}]
     
     - parameter request: (body)  

     - returns: RequestBuilder<Setting> 
     */
    open class func settingsSaveSettingWithRequestBuilder(request: SaveSettingRequest) -> RequestBuilder<Setting> {
        let path = "/Settings"
        let URLString = SwaggerClientAPI.basePath + path
        let parameters = JSONEncodingHelper.encodingParameters(forEncodableObject: request)

        let url = URLComponents(string: URLString)

        let requestBuilder: RequestBuilder<Setting>.Type = SwaggerClientAPI.requestBuilderFactory.getBuilder()

        return requestBuilder.init(method: "POST", URLString: (url?.string ?? URLString), parameters: parameters, isBody: true)
    }

}
