import Foundation

// MARK: - Network Manager Implementation
public final class KNetKitManager: @unchecked Sendable {
    private let configuration: KNetKitManagerConfiguration
    private let authProvider: KNetKitAuthProvider?
    private let logger: KNetKitLogger?
    private let session: URLSession

    public init(
        configuration: KNetKitManagerConfiguration,
        authProvider: KNetKitAuthProvider? = nil,
        logger: KNetKitLogger? = nil
    ) {
        self.configuration = configuration
        self.authProvider = authProvider
        self.logger = logger

        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = configuration.timeoutInterval
        // Set default headers for the session, if desired.
        sessionConfig.httpAdditionalHeaders = configuration.defaultHeaders
        self.session = URLSession(configuration: sessionConfig)
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    // MARK: - Async/Await Request Method
    
    /// Performs a network request using async/await and decodes the response.
    /// - Parameters:
    ///   - endpoint: The API endpoint to call.
    ///   - queryParameters: Optional query parameters.
    ///   - decoder: JSONDecoder to use for decoding the response.
    /// - Returns: A decoded response of type T.
    public func request<T: Decodable & Sendable>(
        _ endpoint: Endpoint,
        queryParameters: [String: String]? = nil,
        decoder: JSONDecoder = JSONDecoder()
    ) async throws -> T {
        let urlRequest = try await buildURLRequest(for: endpoint, queryParameters: queryParameters)
        logger?.log(request: urlRequest)
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await session.data(for: urlRequest)
        } catch {
            logger?.log(error: error, forRequest: urlRequest)
            throw NetworkError.underlying(error)
        }
        
        logger?.log(response: response, data: data)
        try validate(response: response, data: data)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - Helper Methods
    
    private func buildURLRequest(
        for endpoint: Endpoint,
        queryParameters: [String: String]? = nil
    ) async throws -> URLRequest {
        // Construct the full URL.
        guard var components = URLComponents(url: configuration.baseURL, resolvingAgainstBaseURL: false) else {
            throw NetworkError.invalidURL
        }
        
        // Append the endpoint's path.
        components.path = (components.path as NSString).appendingPathComponent(endpoint.path)
        
        // Append query parameters if any.
        if let queryParameters = queryParameters, !queryParameters.isEmpty {
            components.queryItems = queryParameters.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components.url else {
            throw NetworkError.invalidURL
        }
        
        // Create the URLRequest.
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Set headers.
        // Start with default headers.
        configuration.defaultHeaders.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        // Add endpoint-specific headers.
        endpoint.additionalHeaders?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // If the endpoint requires authorization, attempt to set the auth header.
        if endpoint.requiresAuth, let authProvider = authProvider {
            guard let token = await authProvider.authToken,
                  let type = await authProvider.tokenType else {
                throw NetworkError.authError
            }
            request.setValue("\(type) \(token)", forHTTPHeaderField: "Authorization")
        }
        
        // Set HTTP body if provided.
        if let body = endpoint.body {
            request.httpBody = body
        }
        
        return request
    }
    
    /// Validates the response. Throws an error for non-200 status codes.
    private func validate(response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidURL
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            // All good.
            return
        default:
            throw NetworkError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
    }
}
