import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

struct Endpoint {
    var path: String
    var method: HTTPMethod = .get
    var queryItems: [URLQueryItem] = []
    var body: Data? = nil
    var requiresAuth: Bool = false

    func url(baseURL: URL) -> URL {
        var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        return components?.url ?? baseURL.appendingPathComponent(path)
    }
}
