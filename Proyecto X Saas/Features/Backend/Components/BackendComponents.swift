import SwiftUI

// MARK: - Shared Backend UI Components

struct CategoryCard: View {
    let category: ProductCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: AppTheme.Spacing.xs) {
                Image(systemName: "tag.fill")
                    .font(.title2)
                
                Text(category.rawValue)
                    .captionText()
                    .fontWeight(isSelected ? .semibold : .regular)
            }
            .padding(AppTheme.Spacing.sm)
            .frame(width: 80)
            .background(isSelected ? AppTheme.Colors.primary.opacity(0.1) : AppTheme.Colors.cardBackground)
            .foregroundColor(isSelected ? AppTheme.Colors.primary : AppTheme.Colors.primaryText)
            .cornerRadius(AppTheme.CornerRadius.medium)
        }
    }
}

struct EventRowBackend: View {
    let event: Event
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.sm) {
            // Date section
            VStack(spacing: 2) {
                Text(event.dateText)
                    .captionText()
                    .fontWeight(.semibold)
                    .foregroundColor(Color(event.category.color))
                
                Text(event.dayOfWeek)
                    .font(.caption2)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(event.category.color))
                    .frame(width: 30, height: 3)
            }
            .frame(width: 50)
            
            // Event info
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(event.title)
                        .bodyText()
                        .fontWeight(.semibold)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    if event.isFree {
                        Text("GRATIS")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .cornerRadius(4)
                    } else {
                        Text(event.priceText)
                            .bodyText()
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.Colors.primary)
                    }
                }
                
                Text(event.description)
                    .captionText()
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .lineLimit(2)
                
                HStack(spacing: AppTheme.Spacing.md) {
                    // Time and duration
                    HStack(spacing: 2) {
                        Image(systemName: "clock")
                            .font(.caption)
                        Text("\(event.time) • \(event.duration)")
                            .captionText()
                    }
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    
                    Spacer()
                    
                    // Category badge
                    HStack(spacing: 2) {
                        Image(systemName: event.category.icon)
                            .font(.caption)
                        Text(event.category.rawValue)
                            .captionText()
                    }
                    .foregroundColor(Color(event.category.color))
                }
                
                HStack {
                    // Location
                    HStack(spacing: 2) {
                        Image(systemName: "location")
                            .font(.caption)
                        Text(event.location)
                            .captionText()
                            .lineLimit(1)
                    }
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    
                    Spacer()
                    
                    // Available tickets
                    if event.availableTickets > 0 {
                        Text("\(event.availableTickets) tickets")
                            .captionText()
                            .foregroundColor(.green)
                    } else {
                        Text("Agotado")
                            .captionText()
                            .foregroundColor(.red)
                    }
                }
            }
        }
        .padding(AppTheme.Spacing.sm)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
        .shadow(
            color: AppTheme.Shadow.small.color,
            radius: AppTheme.Shadow.small.radius,
            x: AppTheme.Shadow.small.x,
            y: AppTheme.Shadow.small.y
        )
    }
}

#Preview {
    if let sampleEvent = createSampleEvent() {
        EventRowBackend(event: sampleEvent)
            .padding()
    } else {
        Text("No sample event available")
    }
}

private func createSampleEvent() -> Event? {
    return Event(
        id: "1",
        title: "Masterclass de Sushi",
        description: "Aprende a preparar sushi auténtico con el Chef Hiroshi",
        fullDescription: "Masterclass completa para aprender técnicas de sushi japonés con el chef Hiroshi",
        date: "2025-08-15T19:00:00Z",
        time: "19:00",
        duration: "2h 30m",
        location: "Cooking Studio Madrid",
        address: "Calle Serrano 45, Madrid",
        category: .gastronomico,
        price: 60.0,
        capacity: 20,
        availableTickets: 12,
        organizer: "Chef Hiroshi",
        isSponsored: false,
        requirements: [],
        includes: ["Ingredientes", "Utensilios", "Certificado"],
        tags: ["sushi", "masterclass", "japones"],
        imageName: nil,
        createdAt: "2025-08-10T10:00:00Z",
        updatedAt: nil
    )
}