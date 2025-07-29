import SwiftUI

struct MemberCardView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingQRCode = false
    
    private let memberData = MembershipData(
        name: "Jhon Miranda",
        memberId: "628773365",
        memberSince: "Jul 2025",
        level: "Gold",
        points: 1250,
        nextLevelPoints: 1500,
        validUntil: "Jul 2026"
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xxl) {
                    membershipCardSection
                    quickStatsSection
                    benefitsSection
                    qrCodeSection
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.lg)
            }
            .navigationTitle("Tarjeta de Miembro")
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
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Compartir") {
                        // Acción de compartir
                    }
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.brandPrimary)
                }
            }
            .background(AppTheme.Colors.groupedBackground)
        }
    }
    
    private var membershipCardSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Tarjeta principal
            ZStack {
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large)
                    .fill(
                        LinearGradient(
                            colors: [
                                AppTheme.Colors.brandPrimary,
                                AppTheme.Colors.brandPrimary.opacity(0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 200)
                    .shadow(
                        color: AppTheme.Colors.brandPrimary.opacity(0.3),
                        radius: 20,
                        x: 0,
                        y: 10
                    )
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
                    // Header de la tarjeta
                    HStack {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text("PROYECTO X SAAS")
                                .font(AppTheme.Typography.caption1)
                                .fontWeight(.bold)
                                .foregroundColor(AppTheme.Colors.background.opacity(0.9))
                            
                            Text("MEMBER CARD")
                                .font(AppTheme.Typography.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(AppTheme.Colors.background)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "medal.fill")
                            .font(.system(size: 32))
                            .foregroundColor(AppTheme.Colors.background)
                    }
                    
                    Spacer()
                    
                    // Información del miembro
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                        Text(memberData.name.uppercased())
                            .font(AppTheme.Typography.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.Colors.background)
                        
                        Text("ID: \(memberData.memberId)")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.background.opacity(0.9))
                    }
                    
                    // Footer de la tarjeta
                    HStack {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text("NIVEL")
                                .font(AppTheme.Typography.caption2)
                                .foregroundColor(AppTheme.Colors.background.opacity(0.7))
                            Text(memberData.level)
                                .font(AppTheme.Typography.caption1)
                                .fontWeight(.semibold)
                                .foregroundColor(AppTheme.Colors.background)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs) {
                            Text("VÁLIDA HASTA")
                                .font(AppTheme.Typography.caption2)
                                .foregroundColor(AppTheme.Colors.background.opacity(0.7))
                            Text(memberData.validUntil)
                                .font(AppTheme.Typography.caption1)
                                .fontWeight(.semibold)
                                .foregroundColor(AppTheme.Colors.background)
                        }
                    }
                }
                .padding(AppTheme.Spacing.lg)
            }
        }
    }
    
    private var quickStatsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Estadísticas Rápidas")
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            HStack(spacing: AppTheme.Spacing.lg) {
                StatCard(
                    title: "Puntos",
                    value: "\(memberData.points)",
                    icon: "star.fill",
                    color: AppTheme.Colors.storeRating
                )
                
                StatCard(
                    title: "Pedidos",
                    value: "47",
                    icon: "bag.fill",
                    color: AppTheme.Colors.brandPrimary
                )
                
                StatCard(
                    title: "Ahorro Total",
                    value: "$340",
                    icon: "dollarsign.circle.fill",
                    color: AppTheme.Colors.success
                )
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private var benefitsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Beneficios \(memberData.level)")
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            VStack(spacing: AppTheme.Spacing.md) {
                BenefitRow(
                    icon: "percent",
                    title: "15% descuento en pedidos",
                    description: "Descuento automático en todos los pedidos"
                )
                
                BenefitRow(
                    icon: "star.fill",
                    title: "Puntos dobles los viernes",
                    description: "Acumula puntos extra todos los viernes"
                )
                
                BenefitRow(
                    icon: "gift.fill",
                    title: "Regalo de cumpleaños",
                    description: "Producto gratis en tu mes de cumpleaños"
                )
                
                BenefitRow(
                    icon: "crown.fill",
                    title: "Acceso prioritario",
                    description: "Soporte prioritario y ofertas exclusivas"
                )
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private var qrCodeSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Button(action: {
                showingQRCode.toggle()
            }) {
                HStack {
                    Image(systemName: "qrcode")
                        .font(AppTheme.Typography.title3)
                    Text("Mostrar Código QR")
                        .font(AppTheme.Typography.subheadline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(AppTheme.Colors.brandPrimary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, AppTheme.Spacing.md)
                .background(AppTheme.Colors.brandPrimary.opacity(0.1))
                .cornerRadius(AppTheme.CornerRadius.medium)
            }
            
            Text("Presenta este código QR en las tiendas participantes para obtener tus descuentos y acumular puntos.")
                .font(AppTheme.Typography.caption1)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, AppTheme.Spacing.xxxl)
        .sheet(isPresented: $showingQRCode) {
            QRCodeView(memberData: memberData)
        }
    }
}

// MARK: - Supporting Components
struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Image(systemName: icon)
                .font(AppTheme.Typography.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(AppTheme.Typography.title3)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Text(title)
                .font(AppTheme.Typography.caption1)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.Spacing.md)
        .background(AppTheme.Colors.fillColor)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
}

struct BenefitRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: AppTheme.Spacing.md) {
            Image(systemName: icon)
                .font(AppTheme.Typography.title3)
                .foregroundColor(AppTheme.Colors.brandPrimary)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                Text(title)
                    .font(AppTheme.Typography.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text(description)
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            
            Spacer()
        }
    }
}

struct QRCodeView: View {
    let memberData: MembershipData
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: AppTheme.Spacing.xxl) {
                Spacer()
                
                VStack(spacing: AppTheme.Spacing.lg) {
                    // QR Code simulado
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .fill(AppTheme.Colors.primaryText)
                        .frame(width: 200, height: 200)
                        .overlay(
                            Image(systemName: "qrcode")
                                .font(.system(size: 100))
                                .foregroundColor(AppTheme.Colors.background)
                        )
                    
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text(memberData.name)
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        Text("ID: \(memberData.memberId)")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        
                        Text("\(memberData.level) Member")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.brandPrimary)
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.xs)
                            .background(AppTheme.Colors.brandPrimary.opacity(0.1))
                            .cornerRadius(AppTheme.CornerRadius.small)
                    }
                }
                
                Spacer()
                
                Text("Presenta este código en las tiendas participantes")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppTheme.Spacing.xl)
            }
            .padding(AppTheme.Spacing.xl)
            .navigationTitle("Código QR")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Data Model
struct MembershipData {
    let name: String
    let memberId: String
    let memberSince: String
    let level: String
    let points: Int
    let nextLevelPoints: Int
    let validUntil: String
}

#Preview {
    MemberCardView()
}
