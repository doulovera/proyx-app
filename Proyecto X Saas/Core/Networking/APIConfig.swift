import Foundation

struct APIConfig {
    static let shared = APIConfig()

    let baseURL: URL
    let timeout: TimeInterval = 30

    private init() {
        // #if DEBUG
        // // Local development backend
        // self.baseURL = URL(string: "http://127.0.0.1:8080")!
        // #else
        // // Production backend
        self.baseURL = URL(string: "https://tumb-api.up.railway.app")!
        // #endif
    }
}
