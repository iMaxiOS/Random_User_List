//
//  Router.swift
//  Random-User-List
//
//  Created by iMaxiOS on 9/28/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

let encodedRequestHelper: ((HTTPMethod, [String: AnyObject]?, URL) throws -> URLRequest) = { method, parameters, url in
    var _urlRequest = URLRequest(url: url)
    
    _urlRequest.httpMethod = method.rawValue
    return try URLEncoding.default.encode(_urlRequest, with: parameters)
}

struct Router {
    
    enum UserRequest: URLRequestConvertible {
        static let baseURLString = "https://randomuser.me/api/"
        case getUsersRouter([String: AnyObject])
        
        func asURLRequest() throws -> URLRequest {
            var method: HTTPMethod {
                switch self {
                case .getUsersRouter:
                    return .get
                }
            }
            
            let params: ([String: AnyObject]?) = {
                switch self {
                case .getUsersRouter(let newPost):
                    return newPost
                }
            }()
            
            let url: URL = {
                let relativePath:String?
                switch self {
                case .getUsersRouter:
                    relativePath = ""
                }
                
                
                var url = Foundation.URL(string: UserRequest.baseURLString)!
                if let relativePath = relativePath {
                    url = url.appendingPathComponent(relativePath)
                }
                return url
            }()
            
            return try encodedRequestHelper(method, params, url)
        }
    }
}
