//
//  NetworkError.swift
//  KNetKitSwift
//
//  Created by Kusal on 2025-02-25.
//

import Foundation

//public enum NetworkError: Error {
//    case invalidURL
//    case noInternetConnection
//    case timeout
//    case clientError(statusCode: Int, message: String)
//    case serverError(statusCode: Int, message: String)
//    case decodingFailed(message: String)
//    case unknown(statusCode: Int, message: String)
//    case sessionExpired
//    
//    public var localizedDescription: String {
//        switch self {
//        case .invalidURL:
//            return "Invalid URL format"
//        case .noInternetConnection:
//            return "No internet connection"
//        case .timeout:
//            return "Request timed out"
//        case let .clientError(statusCode, message):
//            return "Client error (\(statusCode)): \(message)"
//        case let .serverError(statusCode, message):
//            return "Server error (\(statusCode)): \(message)"
//        case let .decodingFailed(message):
//            return "Decoding failed: \(message)"
//        case let .unknown(statusCode, message):
//            return "Unknown error (\(statusCode)): \(message)"
//        case .sessionExpired:
//            return "Session Expired"
//        }
//    }
//}

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
