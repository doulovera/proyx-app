import Foundation

struct LegacyEvent: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let description: String
    let fullDescription: String
    let date: String // ISO8601 string from API
    let time: String
    let duration: String
    let location: String
    let address: String
    let category: LegacyEventCategory
    let price: Double
    let capacity: Int
    let availableTickets: Int
    let organizer: String
    let isSponsored: Bool
    let requirements: [String]
    let includes: [String]
    let tags: [String]
    let imageName: String?
    let createdAt: String
    let updatedAt: String?
    
    // Computed properties for UI
    var parsedDate: Date {
        return ISO8601DateFormatter().date(from: date) ?? Date()
    }
    
    var isToday: Bool {
        Calendar.current.isDateInToday(parsedDate)
    }
    
    var isThisWeek: Bool {
        let calendar = Calendar.current
        return calendar.isDate(parsedDate, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    var isFree: Bool {
        return price == 0
    }
    
    var priceText: String {
        return isFree ? "Gratis" : "$\(Int(price))"
    }
    
    var dateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: parsedDate)
    }
    
    var dayOfWeek: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = Locale(identifier: "es_ES")
        return formatter.string(from: parsedDate).capitalized
    }

    init(id: String = UUID().uuidString,
         title: String,
         description: String,
         fullDescription: String,
         date: Date,
         time: String,
         duration: String,
         location: String,
         address: String,
         category: LegacyEventCategory,
         price: Double,
         isSponsored: Bool,
         imageName: String? = nil,
         organizer: String,
         capacity: Int,
         availableTickets: Int,
         requirements: [String],
         includes: [String],
         tags: [String],
         createdAt: String? = nil,
         updatedAt: String? = nil) {
        let isoFormatter = ISO8601DateFormatter()
        self.id = id
        self.title = title
        self.description = description
        self.fullDescription = fullDescription
        self.date = isoFormatter.string(from: date)
        self.time = time
        self.duration = duration
        self.location = location
        self.address = address
        self.category = category
        self.price = price
        self.capacity = capacity
        self.availableTickets = availableTickets
        self.organizer = organizer
        self.isSponsored = isSponsored
        self.requirements = requirements
        self.includes = includes
        self.tags = tags
        self.imageName = imageName
        self.createdAt = createdAt ?? isoFormatter.string(from: Date())
        self.updatedAt = updatedAt
    }
}

enum LegacyEventCategory: String, CaseIterable, Codable {
    case gastronomico = "Gastronómico"
    case bebidas = "Bebidas"
    case educativo = "Educativo"
    case cultural = "Cultural"
    case networking = "Networking"
    case entretenimiento = "Entretenimiento"
    
    var icon: String {
        switch self {
        case .gastronomico:
            return "fork.knife"
        case .bebidas:
            return "cup.and.saucer"
        case .educativo:
            return "book"
        case .cultural:
            return "theatermasks"
        case .networking:
            return "person.3"
        case .entretenimiento:
            return "music.note"
        }
    }
    
    var color: String {
        switch self {
        case .gastronomico:
            return "orange"
        case .bebidas:
            return "brown"
        case .educativo:
            return "blue"
        case .cultural:
            return "purple"
        case .networking:
            return "green"
        case .entretenimiento:
            return "pink"
        }
    }
}

class EventStore: ObservableObject {
    @Published var events: [LegacyEvent] = []
    
    init() {
        loadSampleEvents()
    }
    
    private func loadSampleEvents() {
        let calendar = Calendar.current
        let today = Date()
        
        events = [
            // Eventos para HOY
            LegacyEvent(
                title: "Noche de Sushi Premium",
                description: "Disfruta de la mejor selección de sushi artesanal preparado por chef especializado",
                fullDescription: "Una experiencia culinaria única donde podrás degustar los mejores cortes de pescado fresco, preparados al momento por nuestro chef especialista en cocina japonesa. El evento incluye una introducción a la historia del sushi, técnicas de preparación y maridaje con sake premium.\n\nEl menú incluye 12 piezas de sushi premium, 4 tipos de maki especiales, miso soup y postre japonés tradicional.",
                date: today,
                time: "7:00 PM",
                duration: "3 horas",
                location: "Restaurante Sakura",
                address: "Av. Principal 123, Zona Rosa",
                category: .gastronomico,
                price: 65,
                isSponsored: false,
                imageName: "sushi",
                organizer: "Chef Hiroshi Tanaka",
                capacity: 25,
                availableTickets: 8,
                requirements: ["Reserva previa obligatoria", "Edad mínima 18 años"],
                includes: ["Menú degustación completo", "Sake premium", "Certificado de participación"],
                tags: ["Premium", "Japonés", "Chef Especialista"]
            ),
            
            LegacyEvent(
                title: "Cata de Café de Origen",
                description: "Descubre los sabores únicos de cafés de diferentes regiones del mundo",
                fullDescription: "Sumérgete en el fascinante mundo del café con esta cata dirigida por baristas profesionales. Aprenderás sobre el proceso desde el grano hasta la taza, métodos de preparación y cómo identificar las notas de sabor únicas de cada región.\n\nLa experiencia incluye la degustación de 6 variedades premium de café de origen, desde el intenso café etíope hasta el suave colombiano.",
                date: today,
                time: "3:00 PM",
                duration: "2 horas",
                location: "Coffee Lab Studio",
                address: "Calle del Café 45, Centro",
                category: .bebidas,
                price: 0,
                isSponsored: false,
                imageName: "cup.and.saucer",
                organizer: "Baristas Unidos",
                capacity: 20,
                availableTickets: 12,
                requirements: ["Sin restricciones"],
                includes: ["Degustación de 6 cafés", "Manual de cata", "Descuento 20% en productos"],
                tags: ["Gratis", "Educativo", "Café Especial"]
            ),
            
            // Eventos para ESTA SEMANA
            LegacyEvent(
                title: "Festival Gastronómico Internacional",
                description: "Celebración culinaria con platos típicos de 8 países diferentes",
                fullDescription: "Un viaje gastronómico alrededor del mundo sin salir de la ciudad. Chefs de diferentes nacionalidades prepararan platos auténticos de sus países de origen. Una oportunidad única para expandir tu paladar y conocer nuevas culturas a través de su gastronomía.\n\nEl festival contará con estaciones de comida de Italia, México, Tailandia, Francia, India, Japón, Perú y España.",
                date: calendar.date(byAdding: .day, value: 2, to: today) ?? today,
                time: "6:00 PM",
                duration: "5 horas",
                location: "Plaza Central Events",
                address: "Plaza Central, Zona Comercial",
                category: .gastronomico,
                price: 45,
                isSponsored: true,
                imageName: "globe",
                organizer: "Culinary World Events",
                capacity: 200,
                availableTickets: 75,
                requirements: ["Boleto anticipado recomendado"],
                includes: ["Acceso a todas las estaciones", "Bebida incluida", "Show cultural"],
                tags: ["Internacional", "Festival", "Familiar"]
            ),
            
            LegacyEvent(
                title: "Masterclass: Técnicas de Panadería Francesa",
                description: "Aprende los secretos de la repostería francesa con chef certificado",
                fullDescription: "Domina las técnicas tradicionales de la panadería francesa en esta masterclass intensiva. Aprenderás a preparar croissants perfectos, pain au chocolat y baguettes artesanales siguiendo métodos auténticos franceses.\n\nCada participante trabajará con su propia estación equipada y se llevará a casa todo lo que prepare durante la clase.",
                date: calendar.date(byAdding: .day, value: 3, to: today) ?? today,
                time: "9:00 AM",
                duration: "4 horas",
                location: "École Culinaire",
                address: "Av. Francia 78, Distrito Gourmet",
                category: .educativo,
                price: 120,
                isSponsored: false,
                imageName: "leaf",
                organizer: "Chef Marie Dubois",
                capacity: 12,
                availableTickets: 3,
                requirements: ["Nivel básico de cocina", "Delantal propio"],
                includes: ["Ingredientes premium", "Recetario digital", "Productos para llevar"],
                tags: ["Masterclass", "Francés", "Manos a la obra"]
            ),
            
            LegacyEvent(
                title: "Wine & Jazz Evening",
                description: "Noche de vinos premium con música jazz en vivo",
                fullDescription: "Una velada elegante que combina la sofisticación del buen vino con la magia del jazz en vivo. Degusta una selección curada de vinos tintos y blancos de las mejores bodegas mientras disfrutas de música jazz interpretada por músicos locales talentosos.\n\nLa experiencia incluye explicaciones detalladas sobre cada vino por parte de un sommelier certificado.",
                date: calendar.date(byAdding: .day, value: 5, to: today) ?? today,
                time: "8:00 PM",
                duration: "3 horas",
                location: "Terraza Skyline",
                address: "Edificio Torre Vista, Piso 20",
                category: .bebidas,
                price: 85,
                isSponsored: true,
                imageName: "music.note",
                organizer: "Vinos & Cultura",
                capacity: 40,
                availableTickets: 18,
                requirements: ["Edad mínima 21 años", "Código de vestimenta: elegante"],
                includes: ["Degustación de 5 vinos", "Aperitivos gourmet", "Show de jazz"],
                tags: ["Premium", "Jazz", "Vista panorámica"]
            ),
            
            LegacyEvent(
                title: "Taller de Cocina Vegana Creativa",
                description: "Descubre el potencial de la cocina plant-based con recetas innovadoras",
                fullDescription: "Explora las infinitas posibilidades de la cocina vegana en este taller práctico donde aprenderás a crear platos coloridos, nutritivos y llenos de sabor. Desde técnicas de fermentación hasta el uso creativo de especias y superfoods.\n\nIdeal para veganos, vegetarianos y cualquier persona interesada en incorporar más plantas a su dieta.",
                date: calendar.date(byAdding: .day, value: 6, to: today) ?? today,
                time: "11:00 AM",
                duration: "3 horas",
                location: "Green Kitchen Studio",
                address: "Calle Verde 92, Eco District",
                category: .gastronomico,
                price: 0,
                isSponsored: false,
                imageName: "leaf",
                organizer: "Chef Verde Collective",
                capacity: 16,
                availableTickets: 9,
                requirements: ["Sin restricciones alimentarias"],
                includes: ["Ingredientes orgánicos", "Recetario digital", "Comida para llevar"],
                tags: ["Gratis", "Vegano", "Saludable"]
            ),
            
            // Eventos adicionales para llenar la lista
            LegacyEvent(
                title: "Noche de Tapas Españolas",
                description: "Auténticas tapas españolas con flamenco en vivo",
                fullDescription: "Transportate a España con esta noche temática llena de sabores ibéricos auténticos. Disfruta de una amplia variedad de tapas tradicionales preparadas con ingredientes importados directamente de España, acompañadas de un espectáculo de flamenco en vivo.",
                date: calendar.date(byAdding: .day, value: 4, to: today) ?? today,
                time: "7:30 PM",
                duration: "3 horas",
                location: "Casa Española",
                address: "Plaza España 15, Centro Histórico",
                category: .cultural,
                price: 55,
                isSponsored: false,
                imageName: "music.note",
                organizer: "Asociación Cultural España",
                capacity: 35,
                availableTickets: 14,
                requirements: ["Reserva con 24h de anticipación"],
                includes: ["Tapas ilimitadas", "Sangría incluida", "Show de flamenco"],
                tags: ["Español", "Cultural", "Show en vivo"]
            ),
            
            LegacyEvent(
                title: "Networking Gastronómico",
                description: "Conecta con profesionales del sector culinario mientras disfrutas de aperitivos",
                fullDescription: "Un evento diseñado para profesionales, emprendedores y entusiastas de la industria gastronómica. Ideal para establecer contactos, compartir experiencias y descubrir oportunidades de negocio en un ambiente relajado y gourmet.",
                date: calendar.date(byAdding: .day, value: 1, to: today) ?? today,
                time: "6:30 PM",
                duration: "2.5 horas",
                location: "Business Lounge Gourmet",
                address: "Zona Financiera, Torre Corporate",
                category: .networking,
                price: 35,
                isSponsored: false,
                imageName: "person.3",
                organizer: "Gastro Business Network",
                capacity: 50,
                availableTickets: 23,
                requirements: ["Perfil profesional requerido"],
                includes: ["Aperitivos gourmet", "2 bebidas", "Kit de networking"],
                tags: ["Profesional", "Networking", "Business"]
            )
        ]
    }
}
