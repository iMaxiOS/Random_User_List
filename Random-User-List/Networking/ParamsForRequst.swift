//
//  UserRequestWithParams.swift
//  Random-User-List
//
//  Created by iMaxiOS on 10/8/18.
//  Copyright © 2018 Oleg Granchenko. All rights reserved.
//

import Foundation

struct ParamsForRequst {
    typealias Parameters = [String: Any]
    var parameters: Parameters
    
    private init(parameters: Parameters) {
        self.parameters = parameters
    }
}

extension ParamsForRequst {
    static func from() -> ParamsForRequst {
        let defaultParameters: [String : Any] = ["page": 1, "results" : "40", "seed": "abc" ]
        return ParamsForRequst(parameters: defaultParameters)
    }
}
