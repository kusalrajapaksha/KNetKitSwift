//
//  ProtocolDefinitions.swift
//  KNetKitSwift
//
//  Created by Kusal on 2025-02-25.
//

import Foundation

// MARK: - Protocol Definitions
public protocol KNetKitManagerConfiguration: Sendable {
    var baseURL: URL { get }
    var defaultHeaders: [String: String] { get }
    var timeoutInterval: TimeInterval { get }
}

public protocol KNetKitAuthProvider: Sendable {
    var authToken: String? { get async }
    var tokenType: String? { get async }
}

public protocol KNetKitLogger: Sendable {
    func log(request: URLRequest)
    func log(response: URLResponse?, data: Data?)
    func log(error: Error, forRequest request: URLRequest)
}
