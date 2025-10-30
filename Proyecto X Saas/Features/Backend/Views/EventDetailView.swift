import SwiftUI

struct EventDetailView: View {
    let event: Event
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTickets = 1
    @State private var showingPurchaseSheet = false
    @State private var isFavorite = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    headerImageSection
                    eventInfoSection
                    organizerSection
                    descriptionSection
                    includesSection
                    requirementsSection
                    locationSection
                    ticketSection
                }
            }
            .navigationBarHidden(true)
            .background(Color(.systemBackground))
        }
        .sheet(isPresented: $showingPurchaseSheet) {
            PurchaseTicketView(event: event, ticketCount: selectedTickets)
        }
    }
    
    private var headerImageSection: some View {
        ZStack {
            LinearGradient(
                colors: [Color.black.opacity(0.8), Color.gray.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: 280)
            
            VStack(spacing: 20) {
                HStack {
                    Button(action: { dismiss() }) {
                        Circle()
                            .fill(Color.black.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: "xmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                            )
                    }
                    
                    Spacer()
                    
                    Button(action: { isFavorite.toggle() }) {
                        Circle()
                            .fill(Color.black.opacity(0.3))
                            .frame(width: 40, height: 40)
                            .overlay(
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(isFavorite ? .red : .white)
                                    .font(.system(size: 16, weight: .medium))
                            )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                
                Spacer()
                
                VStack(spacing: 12) {
                    Image(systemName: event.category.icon)
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                    
                    if event.isSponsored {
                        Text("EVENTO PATROCINADO")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.yellow)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.black.opacity(0.6))
                            .cornerRadius(15)
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private var eventInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(event.category.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color(.systemGray6))
                    .foregroundColor(.black)
                    .cornerRadius(15)
                
                Spacer()
                
                Text(event.priceText)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(event.isFree ? .green : .black)
            }
            
            Text(event.title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.black)
            
            HStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.gray)
                        Text("Fecha")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text("\(event.dayOfWeek), \(event.dateText)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.gray)
                        Text("Hora")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text(event.time)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "hourglass")
                            .foregroundColor(.gray)
                        Text("Duración")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    Text(event.duration)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }
            
            if event.availableTickets < 20 {
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("¡Solo quedan \(event.availableTickets) entradas disponibles!")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.orange)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
    
    private var organizerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Organizador")
                .font(.headline)
                .fontWeight(.bold)
            
            HStack(spacing: 12) {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    )
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(event.organizer)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text("Organizador verificado")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Button("Seguir") {
                    
                }
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color.black)
                .foregroundColor(.white)
                .cornerRadius(20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemGray6).opacity(0.3))
    }
    
    private var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Descripción del evento")
                .font(.headline)
                .fontWeight(.bold)
            
            Text(event.fullDescription)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineSpacing(4)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var includesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("¿Qué incluye?")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(event.includes, id: \.self) { item in
                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.system(size: 14))
                        
                        Text(item)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var requirementsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Requisitos")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(event.requirements, id: \.self) { requirement in
                    HStack(spacing: 8) {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                            .font(.system(size: 14))
                        
                        Text(requirement)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
    
    private var locationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ubicación")
                .font(.headline)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(event.location)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(event.address)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button("Ver en mapa") {
                    
                }
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(Color(.systemGray6))
                .foregroundColor(.black)
                .cornerRadius(20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemGray6).opacity(0.3))
    }
    
    private var ticketSection: some View {
        VStack(spacing: 16) {
            if !event.isFree {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Cantidad de entradas")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    HStack {
                        Button(action: {
                            if selectedTickets > 1 {
                                selectedTickets -= 1
                            }
                        }) {
                            Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "minus")
                                        .foregroundColor(.black)
                                )
                        }
                        .disabled(selectedTickets <= 1)
                        
                        Spacer()
                        
                        Text("\(selectedTickets)")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            if selectedTickets < min(event.availableTickets, 10) {
                                selectedTickets += 1
                            }
                        }) {
                            Circle()
                                .fill(Color(.systemGray6))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Image(systemName: "plus")
                                        .foregroundColor(.black)
                                )
                        }
                        .disabled(selectedTickets >= min(event.availableTickets, 10))
                    }
                    .padding(.horizontal, 40)
                }
            }
            
            VStack(spacing: 12) {
                if !event.isFree {
                    HStack {
                        Text("Total:")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text("$\(Int(event.price * Double(selectedTickets)))")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
                
                Button(action: {
                    if event.isFree {
                        
                    } else {
                        showingPurchaseSheet = true
                    }
                }) {
                    Text(event.isFree ? "Reservar gratis" : "Comprar entradas")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.black)
                        .cornerRadius(12)
                }
                .disabled(event.availableTickets == 0)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(Color.white)
        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: -5)
    }
}

#Preview {
    EventDetailView(event: Event(
        id: UUID().uuidString,
        title: "Noche de Sushi Premium",
        description: "Disfruta de la mejor selección de sushi artesanal",
        fullDescription: "Una experiencia culinaria única donde podrás degustar los mejores cortes de pescado fresco.",
        date: ISO8601DateFormatter().string(from: Date()),
        time: "7:00 PM",
        duration: "3 horas",
        location: "Restaurante Sakura",
        address: "Av. Principal 123, Zona Rosa",
        category: .gastronomico,
        price: 65,
        capacity: 25,
        availableTickets: 8,
        organizer: "Chef Hiroshi Tanaka",
        isSponsored: true,
        requirements: ["Reserva previa obligatoria"],
        includes: ["Menú degustación completo"],
        tags: ["Premium"],
        imageName: "sushi",
        createdAt: ISO8601DateFormatter().string(from: Date()),
        updatedAt: nil
    ))
}
