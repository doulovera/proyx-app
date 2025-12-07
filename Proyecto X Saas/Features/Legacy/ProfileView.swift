import SwiftUI

struct LegacyProfileView: View {
    let onLogout: () -> Void
    @State private var userPoints = 1250
    @State private var userLevel = "Gold"
    @State private var nextLevelPoints = 1500
    @State private var showingPersonalInfo = false
    @State private var showingMemberCard = false
    @State private var showingPreferences = false
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                profileHeaderSection
                contentSection
            }
            .toolbar(.hidden, for: .navigationBar)
            .background(AppTheme.Colors.groupedBackground)
            .sheet(isPresented: $showingPersonalInfo) {
                PersonalInfoView()
            }
            .sheet(isPresented: $showingMemberCard) {
                MemberCardView()
            }
            .sheet(isPresented: $showingPreferences) {
                PreferencesView()
            }
            .alert("Cerrar Sesión", isPresented: $showingLogoutAlert) {
                Button("Cancelar", role: .cancel) { }
                Button("Cerrar Sesión", role: .destructive) {
                    onLogout()
                }
            } message: {
                Text("¿Estás seguro de que quieres cerrar sesión?")
            }
        }
    }
    
    private var profileHeaderSection: some View {
        VStack(spacing: 0) {
            // Header con gradiente
            ZStack {
                // Gradiente de fondo
                LinearGradient(
                    colors: [
                        AppTheme.Colors.brandPrimary,
                        AppTheme.Colors.brandPrimary.opacity(0.8)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea(edges: .top)
                
                VStack(spacing: AppTheme.Spacing.xl) {
                    // Botón cerrar y espaciado superior
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "bell")
                                .font(AppTheme.Typography.title3)
                                .foregroundColor(AppTheme.Colors.background)
                                .opacity(0.9)
                        }
                    }
                    .padding(.horizontal, AppTheme.Spacing.xl)
                    .padding(.top, AppTheme.Spacing.sm)
                    
                    // Avatar con medalla
                    ZStack {
                        Circle()
                            .fill(AppTheme.Colors.background)
                            .frame(width: 90, height: 90)
                            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                        
                        // Ícono de medalla/premio
                        Image(systemName: "medal.fill")
                            .font(.system(size: 36))
                            .foregroundColor(AppTheme.Colors.brandPrimary)
                    }
                    
                    // Información del usuario
                    VStack(spacing: AppTheme.Spacing.xs) {
                        Text("Jhon Miranda")
                            .font(AppTheme.Typography.title1)
                            .fontWeight(.semibold)
                            .foregroundColor(AppTheme.Colors.background)
                        
                        Text("Miembro desde Jul 2025")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.background.opacity(0.9))
                        
                        Text("#ID: 628773365")
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.background.opacity(0.7))
                            .padding(.top, AppTheme.Spacing.xs)
                    }
                    
                    // Progreso de puntos
                    pointsProgressSection
                        .padding(.bottom, AppTheme.Spacing.xl)
                }
            }
            .frame(height: 380)
        }
    }
    
    private var pointsProgressSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            HStack {
                Image(systemName: "infinity")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.background)
                Text("Progreso de Puntos")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.background)
                
                Spacer()
                
                HStack(spacing: AppTheme.Spacing.xs) {
                    Text("\(userPoints)")
                        .font(AppTheme.Typography.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.background)
                    Text("Puntos")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.background.opacity(0.9))
                    Image(systemName: "chevron.right")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.background.opacity(0.7))
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .fill(AppTheme.Colors.background.opacity(0.15))
            )
            .padding(.horizontal, AppTheme.Spacing.xl)
            
            // Barra de progreso nivel
            VStack(spacing: AppTheme.Spacing.xs) {
                HStack {
                    Text("\(userLevel) Member")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.background.opacity(0.9))
                    Spacer()
                    Text("\(nextLevelPoints - userPoints) puntos para Platinum")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.background.opacity(0.9))
                }
                
                ProgressView(value: Double(userPoints), total: Double(nextLevelPoints))
                    .progressViewStyle(LinearProgressViewStyle())
                    .scaleEffect(x: 1, y: 1.5, anchor: .center)
                    .tint(AppTheme.Colors.background)
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }
    
    private var contentSection: some View {
        ScrollView {
            VStack(spacing: 0) {
                // MY PROFILE Section
                profileSection
                
                // SETTINGS Section  
                settingsSection
            }
            .padding(.top, AppTheme.Spacing.xl)
            .padding(.bottom, AppTheme.Spacing.xxxl)
        }
        .background(AppTheme.Colors.background)
        .cornerRadius(AppTheme.CornerRadius.large, corners: [.topLeft, .topRight])
        .offset(y: -AppTheme.Spacing.lg)
    }
    
    private var profileSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("MI PERFIL")
                .font(AppTheme.Typography.caption1)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .padding(.horizontal, AppTheme.Spacing.xl)
            
            VStack(spacing: 0) {
                ProfileRow(
                    icon: "person.fill",
                    title: "Información Personal",
                    action: {
                        showingPersonalInfo = true
                    }
                )
                
                Divider()
                    .padding(.leading, 60)
                
                ProfileRow(
                    icon: "creditcard.fill",
                    title: "Tarjeta de Miembro",
                    action: {
                        showingMemberCard = true
                    }
                )
                
                Divider()
                    .padding(.leading, 60)
                
                ProfileRow(
                    icon: "heart.fill",
                    title: "Preferencias",
                    action: {
                        showingPreferences = true
                    }
                )
            }
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
        .padding(.bottom, AppTheme.Spacing.xxl)
    }
    
    private var settingsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("CONFIGURACIÓN")
                .font(AppTheme.Typography.caption1)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .padding(.horizontal, AppTheme.Spacing.xl)
            
            VStack(spacing: 0) {
                ProfileRow(
                    icon: "creditcard",
                    title: "Métodos de Pago",
                    action: {}
                )
                
                Divider()
                    .padding(.leading, 60)
                
                ProfileRow(
                    icon: "lock.fill",
                    title: "Seguridad",
                    action: {}
                )
                
                Divider()
                    .padding(.leading, 60)
                
                ProfileRow(
                    icon: "bell.fill",
                    title: "Notificaciones",
                    action: {}
                )
                
                Divider()
                    .padding(.leading, 60)
                
                ProfileRow(
                    icon: "questionmark.circle.fill",
                    title: "Ayuda y Soporte",
                    action: {}
                )
                
                Divider()
                    .padding(.leading, 60)
                
                ProfileRow(
                    icon: "rectangle.portrait.and.arrow.right",
                    title: "Cerrar Sesión",
                    action: {
                        showingLogoutAlert = true
                    },
                    isDestructive: true
                )
            }
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .padding(.horizontal, AppTheme.Spacing.xl)
        }
    }
}

// MARK: - ProfileRow Component
struct ProfileRow: View {
    let icon: String
    let title: String
    let action: () -> Void
    var isDestructive: Bool = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: icon)
                    .font(AppTheme.Typography.title3)
                    .foregroundColor(isDestructive ? AppTheme.Colors.error : AppTheme.Colors.primaryText)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(isDestructive ? AppTheme.Colors.error : AppTheme.Colors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.right")
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(AppTheme.Colors.tertiaryText)
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.lg)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Custom Corner Radius Extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    LegacyProfileView(onLogout: { print("Logout pressed") })
}
