# KNetKitSwift
Swift Network Manager 

KNetKitSwift is a lightweight Swift networking library that uses async/await and URLSession to perform API requests. It’s designed to be highly configurable and easily integrated into your app with minimal setup.

## Features

- **Async/Await Support:** Easily perform network requests using Swift concurrency.
- **Customizable Configuration:** Configure your base URL, headers, timeout, and more.
- **Authentication Support:** Use a custom auth provider to automatically add authorization headers.
- **Logging:** Log requests and responses for debugging.
- **Centralized Setup:** Use `AppNetworkService` to initialize and access your network manager globally.

## Installation

Add MyNetworkPackage to your project via Swift Package Manager.

1. In Xcode, open your project.
2. Navigate to **File > Swift Packages > Add Package Dependency...**
3. Enter the GitHub repository URL for MyNetworkPackage.
4. Follow the prompts to add the package to your project.

```
dependencies: [
    .package(url: ["https://github.com/kusalrajapaksha/KNetKitSwift.git", from: "1.0.0")
]
```

## Usage

### 1. Configure Your App’s Network Service

In your app, create your custom configuration, authentication provider, and logger.

#### **AppNetworkConfiguration.swift**

```swift
import Foundation
import MyNetworkPackage

struct AppNetworkConfiguration: NetworkManagerConfiguration {
    var baseURL: URL {
        URL(string: "https://your-api.com")! // Change to your API base URL.
    }
    
    var defaultHeaders: [String: String] {
        ["Content-Type": "application/json"]
    }
    
    var timeoutInterval: TimeInterval {
        30.0 // Timeout interval in seconds.
    }
    
    var sessionConfiguration: URLSessionConfiguration {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeoutInterval
        return config
    }
}
```

#### **SimpleAuthProvider.swift**

```swift
import Foundation
import MyNetworkPackage

import Foundation
import MyNetworkPackage

actor SimpleAuthProvider: NetworkAuthProvider {
    var authToken: String? {
        get async { "your_access_token" } // Retrieve your token securely.
    }
    
    var tokenType: String? {
        get async { "Bearer" }
    }
}
```

#### **ConsoleLogger.swift**

```swift
import Foundation
import MyNetworkPackage

struct ConsoleLogger: NetworkLogger {
    func log(request: URLRequest) {
        print("➡️ Request: \(request.httpMethod ?? "") \(request.url?.absoluteString ?? "")")
        if let headers = request.allHTTPHeaderFields {
            print("Headers: \(headers)")
        }
        if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
            print("Body: \(bodyString)")
        }
    }
    
    func log(response: HTTPURLResponse?, data: Data?) {
        print("⬅️ Response: \(response?.statusCode ?? 0)")
        if let data = data, let responseBody = String(data: data, encoding: .utf8) {
            print("Response Body: \(responseBody)")
        }
    }
    
    func log(error: Error, forRequest request: URLRequest) {
        print("❌ Error: \(error.localizedDescription) for \(request.url?.absoluteString ?? "")")
    }
}
```

### 2. Centralize Your Setup with AppNetworkService

Create an AppNetworkService class that initializes your network manager with the above dependencies. This ensures your configuration is set up once and is available globally.

#### **AppNetworkService.swift**

```swift
import Foundation
import MyNetworkPackage

final class AppNetworkService {
    static let shared = AppNetworkService() // Singleton instance.
    
    let networkManager: NetworkManager
    
    private init() {
        let config = AppNetworkConfiguration()
        let authProvider = SimpleAuthProvider()
        let logger = ConsoleLogger()
        
        self.networkManager = NetworkManager(
            configuration: config,
            authProvider: authProvider,
            logger: logger
        )
    }
}
```

### 3. Initialize AppNetworkService in Your App Entry Point

For SwiftUI apps, initialize it in your @main App struct. For UIKit apps, you can initialize it in your AppDelegate.

#### **SwiftUI Example (MyApp.swift)**

```swift
import SwiftUI
import MyNetworkPackage

@main
struct MyApp: App {
    init() {
        _ = AppNetworkService.shared // Initializes the network service.
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

#### **UIKit Example (AppDelegate.swift)**

```swift
import UIKit
import MyNetworkPackage

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        _ = AppNetworkService.shared // Initialize your network service.
        return true
    }
}
```

### 4. Using the Network Manager

Now, anywhere in your app, you can access your network manager via the singleton:

```swift
import MyNetworkPackage

// Define your API endpoint.
let getUsersEndpoint = Endpoint(
    path: "users",
    method: .get,
    requiresAuth: true
)

// Use async/await to perform a request.
func fetchUsers() async {
    do {
        let users: [User] = try await AppNetworkService.shared.networkManager.request(getUsersEndpoint)
        print("Fetched users:", users)
    } catch {
        print("Error fetching users:", error)
    }
}
```

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## License

This project is licensed under the MIT License.
