import Foundation
import Alamofire
import SwiftyJSON

enum Result<T> {
    case Success(T, Int)
    case Invalid(String, Int)
    case Failure(Error, Int)
}


enum HeaderType {
    case Guest
    case UserSession
    case UserSessionUTF
    case Contents
    case None
}


enum HTTPHeaderField: String {
    case authorization = "Authorization"
    case contentType = "Content-Type"
    case acceptType = "Accept"
    case acceptEncoding = "Accept-Encoding"
}


enum ContentType: String {
    case json = "application/json"
    case formData = "application/x-www-form-urlencoded"
    case multipartFormData = "multipart/form-data"
    case jsonUtf = "application/json; charset=utf-8"
}


struct MaltipartData {
    var data: Data
    var name: String // profile_pic
    var fileName: String // file.jpg
    var mimeType: String // image/jpg
}


private func getHeaders(_ type: HeaderType) -> HTTPHeaders {
    
    switch type {
    case .Guest:
        return [
            HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue
        ]
    case .UserSession:
        return [
            HTTPHeaderField.authorization.rawValue: "Bearer \(UserDefaults.standard.string(forKey: "x-access-token") ?? "")" ,
            HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue
        ]
    case .UserSessionUTF:
        return [
            HTTPHeaderField.authorization.rawValue: "Bearer \(UserDefaults.standard.string(forKey: "x-access-token") ?? "")",
            HTTPHeaderField.acceptType.rawValue: ContentType.jsonUtf.rawValue
        ]
    case .Contents:
        return [
            HTTPHeaderField.acceptType.rawValue: ContentType.json.rawValue
        ]
    case .None:
        return [:]
    }
}


struct URLDataRequest {
    
    private var urlString: String
    private var headerType: HeaderType
    private var parameters: [String : Any]?
    private var httpMethod: HTTPMethod
    private var arguments: String?
    private var multipartData: [MaltipartData]?
    private var requestEncoding: ParameterEncoding
    
    
    //MARK: Normal form - Ex: base_url/end_point -> (GET, POST, PUT, DELETE)
    init(url: String, header: HeaderType, param: [String : Any]?, method: HTTPMethod = .get, encoding: ParameterEncoding = JSONEncoding.default) {
        urlString = url.addingPercentEncoding(withAllowedCharacters : CharacterSet.urlQueryAllowed) ?? ""
        headerType = header
        parameters = param
        httpMethod = method
        requestEncoding = encoding
    }
    
    
    /*//MARK: Normal form with arguments - Ex: base_url/end_point/argument -> (GET, POST, PUT, DELETE)
     init(url: String, args: String, header: HeaderType, param: [String : Any]?, method: HTTPMethod = .get) {
     urlString = url.addingPercentEncoding(withAllowedCharacters : CharacterSet.urlQueryAllowed) ?? ""
     arguments = args
     headerType = header
     parameters = param
     httpMethod = method
     }*/
    
    
    //MARK: Multipart form
    init(url: String, header: HeaderType, param: [String : Any]?, formData: [MaltipartData], encoding: ParameterEncoding = JSONEncoding.default) {
        urlString = url.addingPercentEncoding(withAllowedCharacters : CharacterSet.urlQueryAllowed) ?? ""
        headerType = header
        parameters = param
        httpMethod = .post
        multipartData = formData
        requestEncoding = encoding
    }
    
    /*//MARK: Multipart form with arguments - Ex: base_url/end_point/argument -> (POST)
     init(url: String, args: String, header: HeaderType, param: [String : Any]?, formData: [MaltipartData]) {
     urlString = url.addingPercentEncoding(withAllowedCharacters : CharacterSet.urlQueryAllowed) ?? ""
     arguments = args
     headerType = header
     parameters = param
     httpMethod = .post
     multipartData = formData
     }
     
     //MARK: Check internet connection
     func checkInternetConnection() {
     if let manager = NetworkReachabilityManager(), !manager.isReachable {
     DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
     // Your code here
     let banner = StatusBarNotificationBanner(title: "The Internet connection appears to be offline.", style: .danger)
     banner.haptic = .heavy
     banner.show()
     }
     }
     }*/
    
    
    //MARK: Normal Request
    public func requestData(completion: @escaping (Result<Data>) -> Void) {
        // Check internet connection availability
        //checkInternetConnection()
        
        // Show Activity Indicator
        NetworkActivityIndicatorManager.networkOperationStarted()
        
        print("**** REQUEST INFO ****")
        print("URL: ========> \(urlString)")
        print("HTTP METHOD: ====> \(httpMethod)")
        print("HEADERS: ====> \(getHeaders(headerType))")
        print("PARAMETERS: => \(parameters ?? [:])")
        print("ARGUMENTS: => \(arguments ?? "")")
        
        // Continue with Alamofire request
        
        Alamofire.request(urlString, method: httpMethod, parameters: httpMethod == .get ? nil : parameters, encoding: requestEncoding, headers: getHeaders(headerType))
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
        }
        .validate()
        .responseJSON { response in
            // Hide Activity Indicator
            NetworkActivityIndicatorManager.networkOperationFinished()
            
            let statusCode = response.response?.statusCode ?? 0
            print("GOINGPARAM \(self.parameters)")
            switch response.result {
                
            case .success:
                if let data = response.data {
                    switch statusCode {
                    case 200...299:
                        completion(.Success(data, statusCode))
                    default:
                        let json = JSON(data)
                        let message = json["message"].stringValue ?? ""
                        completion(.Invalid(message, statusCode))
                    }
                }
            case .failure(let error):
                completion(.Failure(error, statusCode))
            }
        }
    }
    
    
    //MARK: Multipart Upload
    public func uploadData(completion: @escaping (Result<Data>) -> Void) {
        // Check internet connection availability
        //checkInternetConnection()
        
        // Show Activity Indicator
        NetworkActivityIndicatorManager.networkOperationStarted()
        
        print("**** UPLOAD INFO ****")
        print("URL: ========> \(urlString)")
        print("HTTP METHOD: ====> \(httpMethod)")
        print("HEADERS: ====> \(getHeaders(headerType))")
        print("PARAMETERS: => \(parameters ?? [:])")
        print("ARGUMENTS: => \(arguments ?? "")")
        print("MULTIPART DATA COUNT: => \(multipartData?.count ?? 0)")
        
        // Continue with Alamofire upload
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            if let multipartData = self.multipartData {
                
                multipartData.forEach({ multipartDataItem in
                    multipartFormData.append(multipartDataItem.data, withName: multipartDataItem.name, fileName: multipartDataItem.fileName, mimeType: multipartDataItem.mimeType)
                })
            }
            
            if let param = self.parameters {
                for (key, value) in param {
                    multipartFormData.append(("\(value)").data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, to: urlString, method: httpMethod, headers: getHeaders(headerType)) { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    //                    log.debug("Upload Progress: \(progress.fractionCompleted)")
                })
                
                upload.downloadProgress { progress in // called on main queue by default
                    //                        log.debug("Download Progress: \(progress.fractionCompleted)")
                }
                
                upload.validate { request, response, data in
                    // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                    return .success
                }
                
                upload.responseJSON { response in
                    // Hide Activity Indicator
                    NetworkActivityIndicatorManager.networkOperationFinished()
                    
                    let statusCode = response.response?.statusCode ?? 0
                    
                    switch response.result {
                    case .success:
                        if let data = response.data {
                            switch statusCode {
                            case 200...299:
                                completion(.Success(data, statusCode))
                            default:
                                let json = JSON(data)
                                let message = json["message"].stringValue 
                                completion(.Invalid(message, statusCode))
                            }
                        }
                    case .failure(let error):
                        completion(.Failure(error, statusCode))
                    }
                }
            case .failure(let error):
                // Hide Activity Indicator
                NetworkActivityIndicatorManager.networkOperationFinished()
                completion(.Failure(error, 500))
            }
        }
    }
    
}
