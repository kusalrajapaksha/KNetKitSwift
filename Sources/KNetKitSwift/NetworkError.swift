//
//  NetworkError.swift
//  KNetKitSwift
//
//  Created by Kusal on 2025-02-25.
//

import Foundation

public enum NetworkError: Error, Sendable {
    case invalidURL
    case noData
    case decodingError(Error)
    case httpError(statusCode: Int, data: Data?)
    case underlying(Error)
    case authError
    
    public var localizedDescription: String {
        switch self {
        case .invalidURL:
            ">>> KNetSwift Error : Invalid URL error"
        case .noData:
            ">>> KNetSwift Error : No data error"
        case .decodingError(let error):
            ">>> KNetSwift Error : Decoding error \(error)"
        case .httpError(let statusCode, let data):
            ">>> KNetSwift Error : HTTP error \(statusCode), with \(String(describing: data))"
        case .underlying(let error):
            ">>> KNetSwift Error : Underlying error \(error)"
        case .authError:
            ">>> KNetSwift Error : Auth error"
        }
    
    }
}
