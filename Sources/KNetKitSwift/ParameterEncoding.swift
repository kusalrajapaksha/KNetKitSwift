//
//  ParameterEncoding.swift
//  KNetKitSwift
//
//  Created by Kusal on 2025-02-25.
//

import Alamofire

public enum ParameterEncoding {
    case json
    case url
    
    var alamofireEncoding: Alamofire.ParameterEncoding {
        switch self {
        case .json: return JSONEncoding.default
        case .url: return URLEncoding.default
        }
    }
}
