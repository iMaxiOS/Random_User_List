//
//  APIManager.swift
//  Random-User-List
//
//  Created by iMaxiOS on 9/28/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

final class APIManager {
    private func requestHandler(_ function: Any, urlRequest: URLRequestConvertible, completionHandler: @escaping (JSON?) -> Void) {
        
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON { response in
                var errorDescription = ""
                var errorReason = ""
                if case let .failure(error) = response.result {
                    if let error = error as? AFError {
                        switch error {
                        case .invalidURL(let url):
                            errorReason = "Invalid URL: " + "\(url) - \(error.localizedDescription)"
                        case .parameterEncodingFailed(let reason):
                            errorDescription = "Parameter encoding failed: " + "\(error.localizedDescription)"
                            errorReason = "Failure Reason: " + "\(reason)"
                        case .multipartEncodingFailed(let reason):
                            errorDescription = "Multipart encoding failed: " + "\(error.localizedDescription)"
                            errorReason = "Failure Reason: " + "\(reason)"
                        case .responseValidationFailed(let reason):
                            errorDescription = "Response validation failed: " + "\(error.localizedDescription)"
                            errorReason = "Failure Reason: " + "\(reason)"
                            
                            switch reason {
                            case .dataFileNil, .dataFileReadFailed:
                                errorDescription = "Downloaded file could not be read"
                            case .missingContentType(let acceptableContentTypes):
                                errorDescription = "Content Type Missing: " + "\(acceptableContentTypes)"
                            case .unacceptableContentType(let acceptableContentTypes, let responseContentType):
                                errorDescription = "Response content type: " + "\(responseContentType) " + "was unacceptable: " + "\(acceptableContentTypes)"
                            case .unacceptableStatusCode(let code):
                                errorDescription = "Response status code was unacceptable: " + "\(code)"
                            }
                        case .responseSerializationFailed(let reason):
                            errorDescription = "Response serialization failed: " + "\(error.localizedDescription)"
                            errorReason = "Failure Reason: " + "\(reason)"
                        }
                        
                        errorDescription =  "Underlying error: " + "\(error.underlyingError!)"
                    } else if let error = error as? URLError {
                        errorDescription = "URLError occurred: " + "\(error)"
                    } else {
                        errorDescription = "Unknown error: " + "\(error)"
                    }
                    completionHandler(nil)
                }
                
                if case let .success(value) = response.result {
                    let json = JSON(value)
                    
                    completionHandler(json)
                }
                //Print log
                if !errorDescription.isEmpty, !errorReason.isEmpty {
                    print("errorDescription: \(errorDescription),\n errorReason: \(errorReason)")
                }
        }
    }
    
    //MARK: Methods
    func getUsersList (_ entryParams: [String : AnyObject], completion: @escaping (JSON) -> Void) {
        requestHandler(#function, urlRequest: Router.UserRequest.getUsersRouter(entryParams), completionHandler: { json in
            guard let json = json else {
                return
            }
            print (json)
            completion(json)
        })
    }
}

