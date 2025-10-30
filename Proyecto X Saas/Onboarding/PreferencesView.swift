import SwiftUI

struct PreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Preferencias de comida
    @State private var vegetarian = false
    @State private var vegan = true
    @State private var glutenFree = false
    @State private var nutAllergy = false
    @State private var spicyFood = true
    @State private var organicFood = true
    
    // Preferencias de entrega
    @State private var deliveryRadius = 5.0
    @State private var preferredDeliveryTime = "19:00"
    @State private var weekendDelivery = true
    @State private var contactlessDelivery = true
    
    // Preferencias de notificaciones
    @State private var orderUpdates = true
    @State private var promotionsNotifications = true
    @State private var newRestaurants = false
    @State private var weeklyDigest = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xxl) {
                    dietaryPreferencesSection
                    deliveryPreferencesSection
                    notificationPreferencesSection
                    saveButtonSection
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.lg)
            }
            .navigationTitle("Preferencias")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(AppTheme.Typography.title3)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                }
            }
            .background(AppTheme.Colors.groupedBackground)
        }
    }
    
    private var dietaryPreferencesSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Preferencias Alimentarias")
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            VStack(spacing: 0) {
                PreferenceToggleRow(
                    title: "Vegetariano",
                    description: "Mostrar solo opciones vegetarianas",
                    isOn: $vegetarian
                )
                
                Divider().padding(.leading, 16)
                
                PreferenceToggleRow(
                    title: "Vegano",
                    description: "Filtrar productos veganos",
                    isOn: $vegan
                )
                
                Divider().padding(.leading, 16)
                
                PreferenceToggleRow(
                    title: "Sin Gluten",
                    description: "Destacar opciones libres de gluten",
                    isOn: $glutenFree
                )
                
                Divider().padding(.leading, 16)
                
                PreferenceToggleRow(
                    title: "Alergia a Frutos Secos",
                    description: "Ocultar productos con frutos secos",
                    isOn: $nutAllergy
                )
                
                Divider().padding(.leading, 16)
                
                PreferenceToggleRow(
                    title: "Comida Picante",
                    description: "Incluir opciones picantes en recomendaciones",
                    isOn: $spicyFood
                )
                
                Divider().padding(.leading, 16)
                
                PreferenceToggleRow(
                    title: "Productos Orgánicos",
                    description: "Priorizar productos orgánicos",
                    isOn: $organicFood
                )
            }
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.large)
        }
    }
    
    private var deliveryPreferencesSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Preferencias de Entrega")
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            VStack(spacing: AppTheme.Spacing.lg) {
                // Radio de entrega
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    HStack {
                        Text("Radio de Entrega")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        Spacer()
                        
                        Text("\(Int(deliveryRadius)) km")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.brandPrimary)
                    }
                    
                    Slider(value: $deliveryRadius, in: 1...15, step: 1)
                        .tint(AppTheme.Colors.brandPrimary)
                    
                    Text("Buscar restaurantes dentro de este radio")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
                .padding(AppTheme.Spacing.lg)
                .background(AppTheme.Colors.cardBackground)
                .cornerRadius(AppTheme.CornerRadius.large)
                
                // Hora preferida
                VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                    Text("Hora Preferida de Entrega")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    DatePicker("Hora de entrega", selection: Binding(
                        get: {
                            let formatter = DateFormatter()
                            formatter.dateFormat = "HH:mm"
                            return formatter.date(from: preferredDeliveryTime) ?? Date()
                        },
                        set: { date in
                            let formatter = DateFormatter()
                            formatter.dateFormat = "HH:mm"
                            preferredDeliveryTime = formatter.string(from: date)
                        }
                    ), displayedComponents: .hourAndMinute)
                    .datePickerStyle(CompactDatePickerStyle())
                    
                    Text("Hora sugerida para tus pedidos")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                }
                .padding(AppTheme.Spacing.lg)
                .background(AppTheme.Colors.cardBackground)
                .cornerRadius(AppTheme.CornerRadius.large)
                
                // Opciones adicionales
                VStack(spacing: 0) {
                    PreferenceToggleRow(
                        title: "Entrega en Fines de Semana",
                        description: "Recibir pedidos sábados y domingos",
                        isOn: $weekendDelivery
                    )
                    
                    Divider().padding(.leading, 16)
                    
                    PreferenceToggleRow(
                        title: "Entrega sin Contacto",
                        description: "Preferir entregas sin contacto",
                        isOn: $contactlessDelivery
                    )
                }
                .background(AppTheme.Colors.cardBackground)
                .cornerRadius(AppTheme.CornerRadius.large)
            }
        }
    }
    
    private var notificationPreferencesSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Notificaciones")
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            VStack(spacing: 0) {
                PreferenceToggleRow(
                    title: "Actualizaciones de Pedidos",
                    description: "Estado de preparación y entrega",
                    isOn: $orderUpdates
                )
                
                Divider().padding(.leading, 16)
                
                PreferenceToggleRow(
                    title: "Promociones y Ofertas",
                    description: "Descuentos y promociones especiales",
                    isOn: $promotionsNotifications
                )
                
                Divider().padding(.leading, 16)
                
                PreferenceToggleRow(
                    title: "Nuevos Restaurantes",
                    description: "Cuando se unan nuevos restaurantes",
                    isOn: $newRestaurants
                )
                
                Divider().padding(.leading, 16)
                
                PreferenceToggleRow(
                    title: "Resumen Semanal",
                    description: "Resumen de actividad y puntos",
                    isOn: $weeklyDigest
                )
            }
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.large)
        }
    }
    
    private var saveButtonSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Button("Guardar Preferencias") {
                // Simular guardado
                dismiss()
            }
            .font(AppTheme.Typography.buttonPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.lg)
            .background(AppTheme.Colors.brandPrimary)
            .foregroundColor(AppTheme.Colors.background)
            .cornerRadius(AppTheme.CornerRadius.round)
            
            Button("Restablecer a Predeterminado") {
                // Reset a valores por defecto
                resetToDefaults()
            }
            .font(AppTheme.Typography.subheadline)
            .foregroundColor(AppTheme.Colors.secondaryText)
        }
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }
    
    private func resetToDefaults() {
        vegetarian = false
        vegan = false
        glutenFree = false
        nutAllergy = false
        spicyFood = false
        organicFood = false
        deliveryRadius = 5.0
        preferredDeliveryTime = "19:00"
        weekendDelivery = true
        contactlessDelivery = false
        orderUpdates = true
        promotionsNotifications = false
        newRestaurants = false
        weeklyDigest = true
    }
}

// MARK: - PreferenceToggleRow Component
struct PreferenceToggleRow: View {
    let title: String
    let description: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(title)
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text(description)
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .tint(AppTheme.Colors.brandPrimary)
        }
        .padding(AppTheme.Spacing.lg)
        .contentShape(Rectangle())
        .onTapGesture {
            isOn.toggle()
        }
    }
}

#Preview {
    PreferencesView()
}