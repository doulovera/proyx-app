import Foundation

struct APIClient {
    var tokenProvider: () -> String?

    init(tokenProvider: @escaping () -> String?) {
        self.tokenProvider = tokenProvider
    }

    func send<T: Decodable>(_ endpoint: Endpoint, decodeTo type: T.Type) async throws -> T {
        let request = try buildRequest(for: endpoint)
        let (data, response) = try await URLSession.shared.data(for: request)
        return try handleResponse(data: data, response: response, decodeTo: type)
    }

    func send(_ endpoint: Endpoint) async throws {
        let request = try buildRequest(for: endpoint)
        let (_, response) = try await URLSession.shared.data(for: request)
        try handleResponse(data: Data(), response: response, decodeTo: Empty.self)
    }

    private func buildRequest(for endpoint: Endpoint) throws -> URLRequest {
        let url = endpoint.url(baseURL: APIConfig.shared.baseURL)
        var request = URLRequest(url: url, timeoutInterval: APIConfig.shared.timeout)
        request.httpMethod = endpoint.method.rawValue

        if let body = endpoint.body {
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        if endpoint.requiresAuth, let token = tokenProvider()?.trimmingCharacters(in: .whitespacesAndNewlines), !token.isEmpty {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        return request
    }

    private func handleResponse<T: Decodable>(data: Data, response: URLResponse, decodeTo: T.Type) throws -> T {
        guard let http = response as? HTTPURLResponse else {
            throw APIError.network
        }

        switch http.statusCode {
        case 200...299:
            if decodeTo == Empty.self {
                return Empty() as! T
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                return try decoder.decode(T.self, from: data)
            } catch {
                throw APIError.decoding
            }
        case 400:
            let reason = parseReason(from: data)
            throw APIError.validation(reason ?? "Solicitud inválida.")
        case 401:
            throw APIError.unauthorized
        case 404:
            throw APIError.notFound
        default:
            let reason = parseReason(from: data)
            throw APIError.server(status: http.statusCode, reason: reason)
        }
    }

    private func parseReason(from data: Data) -> String? {
        guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        return json["reason"] as? String
    }
}

private struct Empty: Decodable {}
