import Foundation

struct Event: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let description: String?
    let date: Date
    let time: String?
    let duration: String?
    let location: String?
    let address: String?
    let category: EventCategory
    let price: Double
    let promoUnitPrice: Double?
    let capacity: Int?
    let availableTickets: Int?
    let organizer: String?
    let requirements: [String]?
    let includes: [String]?
    let tags: [String]?
    let isSponsored: Bool?
    let imageURL: String?

    var displayPrice: String {
        if let promo = promoUnitPrice {
            return "S/ \(Int(promo))"
        }
        if price == 0 {
            return "Gratis"
        }
        return "S/ \(Int(price))"
    }

    var isFree: Bool {
        price == 0
    }

    var isToday: Bool {
        Calendar.current.isDateInToday(date)
    }

    var isThisWeek: Bool {
        let calendar = Calendar.current
        let today = Date()
        let weekFromToday = calendar.date(byAdding: .day, value: 7, to: today) ?? today
        return date >= today && date <= weekFromToday
    }

    var shortDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date)
    }

    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: date).capitalized
    }

    var dateText: String {
        shortDate
    }
}

enum EventCategory: String, CaseIterable, Codable {
    case gastronomico
    case bebidas
    case educativo
    case cultural
    case networking
    case entretenimiento

    var icon: String {
        switch self {
        case .gastronomico: return "fork.knife"
        case .bebidas: return "cup.and.saucer"
        case .educativo: return "book"
        case .cultural: return "theatermasks"
        case .networking: return "person.3"
        case .entretenimiento: return "music.note"
        }
    }

    var displayName: String {
        switch self {
        case .gastronomico: return "Gastronómico"
        case .bebidas: return "Bebidas"
        case .educativo: return "Educativo"
        case .cultural: return "Cultural"
        case .networking: return "Networking"
        case .entretenimiento: return "Entretenimiento"
        }
    }
}

struct TicketPurchaseRequestDTO: Codable {
    let quantity: Int
    let paymentReference: String?
    let storeID: UUID?
    let usePoints: Bool
    let usePromo: Bool
}

struct PaymentGatewayResponseDTO: Codable {
    let provider: String
    let orderId: String
    let checkoutUrl: String
    let expiresAt: Date
}

struct OrderResponseDTO: Codable {
    let id: UUID
    let quantity: Int
    let unitPrice: Double?
    let appliedUnitPrice: Double?
    let totalAmount: Double?
    let paymentMethod: String?
    let paymentStatus: String?
    let paymentReference: String?
    let paymentGatewayOrderID: String?
    let usePoints: Bool
    let usePromo: Bool
    let createdAt: Date?
}

struct TicketResponseDTO: Codable, Identifiable {
    let id: UUID
    let ticketNumber: String?
    let qrCode: String?
    let status: String?
    let usedAt: Date?
    let createdAt: Date?
}

struct PurchaseResponseDTO: Codable {
    let order: OrderResponseDTO
    let tickets: [TicketResponseDTO]?
    let paymentGateway: PaymentGatewayResponseDTO?
    let event: Event
}
