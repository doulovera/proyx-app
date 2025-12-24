import Foundation

struct APIConfig {
    static let shared = APIConfig()

    let baseURL: URL
    let timeout: TimeInterval = 30

    private init() {
        // Default to local backend; swap to production URL via build settings if needed.
        self.baseURL = URL(string: "http://127.0.0.1:8080")!
    }
}
