//
//  EndPoint.swift
//  KNetKitSwift
//
//  Created by Kusal on 2025-02-25.
//

import Foundation

public struct Endpoint: Sendable {
    public let path: String
    public let method: HTTPMethod
    public let additionalHeaders: [String: String]?
    public let requiresAuth: Bool
    public let body: Data?  // Pre-encoded body data (e.g. JSON)
    
    public init(
        path: String,
        method: HTTPMethod,
        additionalHeaders: [String: String]? = nil,
        requiresAuth: Bool = true,
        body: Data? = nil
    ) {
        self.path = path
        self.method = method
        self.additionalHeaders = additionalHeaders
        self.requiresAuth = requiresAuth
        self.body = body
    }
}
