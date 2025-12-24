import Foundation

enum APIError: LocalizedError {
    case network
    case decoding
    case server(status: Int, reason: String?)
    case unauthorized
    case notFound
    case validation(String)

    var errorDescription: String? {
        switch self {
        case .network:
            return "Hubo un problema de red. Inténtalo de nuevo."
        case .decoding:
            return "Respuesta inesperada del servidor."
        case .server(let status, let reason):
            return reason ?? "Error del servidor (\(status))."
        case .unauthorized:
            return "Sesión expirada. Inicia sesión nuevamente."
        case .notFound:
            return "Recurso no encontrado."
        case .validation(let message):
            return message
        }
    }
}
