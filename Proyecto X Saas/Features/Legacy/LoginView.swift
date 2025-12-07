import SwiftUI

struct LegacyLoginView: View {
    let onLoginComplete: () -> Void
    let onBack: () -> Void
    let onSignUp: () -> Void
    let onQuickAccess: () -> Void
    
    @State private var email = ""
    @State private var password = ""
    @State private var rememberMe = false
    @State private var showingForgotPassword = false
    @State private var isLoading = false
    @State private var showingError = false
    @State private var errorMessage = ""
    @FocusState private var focusedField: LoginField?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xxl) {
                    headerSection
                    loginFormSection
                    optionsSection
                    actionButtonsSection
                    alternativeLoginSection
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.lg)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: onBack) {
                        Image(systemName: "arrow.left")
                            .font(AppTheme.Typography.title3)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                }
            }
            .background(AppTheme.Colors.groupedBackground)
            .sheet(isPresented: $showingForgotPassword) {
                ForgotPasswordView()
            }
        }
        .onChange(of: email) {
            clearError()
        }
        .onChange(of: password) {
            clearError()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: AppTheme.Spacing.xl) {
            // Logo e ícono
            VStack(spacing: AppTheme.Spacing.lg) {
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(AppTheme.Colors.brandPrimary)
                
                VStack(spacing: AppTheme.Spacing.sm) {
                    Text("Bienvenido de nuevo")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(AppTheme.Colors.primaryText)
                    
                    Text("Ingresa a tu cuenta para continuar")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.top, AppTheme.Spacing.xl)
    }
    
    private var loginFormSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Card principal del formulario
            VStack(spacing: AppTheme.Spacing.lg) {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                    HStack {
                        Text("Iniciar Sesión")
                            .font(AppTheme.Typography.headline)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        Spacer()
                        
                        Button("Datos de ejemplo") {
                            loadExampleData()
                        }
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.brandPrimary)
                        .padding(.horizontal, AppTheme.Spacing.sm)
                        .padding(.vertical, AppTheme.Spacing.xs)
                        .background(AppTheme.Colors.brandPrimary.opacity(0.1))
                        .cornerRadius(AppTheme.CornerRadius.small)
                    }
                    
                    VStack(spacing: AppTheme.Spacing.md) {
                        // Campo de email
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("Correo Electrónico")
                                .font(AppTheme.Typography.subheadline)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            
                            HStack {
                                Image(systemName: "envelope")
                                    .font(AppTheme.Typography.body)
                                    .foregroundColor(AppTheme.Colors.secondaryText)
                                    .frame(width: 20)
                                
                                TextField("ejemplo@correo.com", text: $email)
                                    .font(AppTheme.Typography.body)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .focused($focusedField, equals: .email)
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.sm)
                            .background(AppTheme.Colors.fillColor)
                            .cornerRadius(AppTheme.CornerRadius.small)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                                    .stroke(
                                        focusedField == .email ? AppTheme.Colors.brandPrimary : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                        }
                        
                        // Campo de contraseña
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("Contraseña")
                                .font(AppTheme.Typography.subheadline)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            
                            HStack {
                                Image(systemName: "lock")
                                    .font(AppTheme.Typography.body)
                                    .foregroundColor(AppTheme.Colors.secondaryText)
                                    .frame(width: 20)
                                
                                SecureField("Ingresa tu contraseña", text: $password)
                                    .font(AppTheme.Typography.body)
                                    .foregroundColor(AppTheme.Colors.primaryText)
                                    .focused($focusedField, equals: .password)
                            }
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.sm)
                            .background(AppTheme.Colors.fillColor)
                            .cornerRadius(AppTheme.CornerRadius.small)
                            .overlay(
                                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                                    .stroke(
                                        focusedField == .password ? AppTheme.Colors.brandPrimary : Color.clear,
                                        lineWidth: 2
                                    )
                            )
                        }
                    }
                }
                
                // Mostrar error si existe
                if showingError {
                    HStack {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.error)
                        
                        Text(errorMessage)
                            .font(AppTheme.Typography.caption1)
                            .foregroundColor(AppTheme.Colors.error)
                        
                        Spacer()
                    }
                    .padding(AppTheme.Spacing.sm)
                    .background(AppTheme.Colors.error.opacity(0.1))
                    .cornerRadius(AppTheme.CornerRadius.small)
                }
            }
            .padding(AppTheme.Spacing.lg)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.large)
        }
    }
    
    private var optionsSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Recordarme y olvidé contraseña
            HStack {
                // Recordarme
                Button(action: {
                    rememberMe.toggle()
                }) {
                    HStack(spacing: AppTheme.Spacing.sm) {
                        Image(systemName: rememberMe ? "checkmark.square.fill" : "square")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(rememberMe ? AppTheme.Colors.brandPrimary : AppTheme.Colors.tertiaryText)
                        
                        Text("Recordarme")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.primaryText)
                    }
                }
                
                Spacer()
                
                // Olvidé mi contraseña
                Button("¿Olvidaste tu contraseña?") {
                    showingForgotPassword = true
                }
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.Colors.brandPrimary)
            }
        }
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Botón principal de login
            Button(action: performLogin) {
                HStack {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.background))
                            .scaleEffect(0.8)
                    } else {
                        Text("Iniciar Sesión")
                            .font(AppTheme.Typography.buttonPrimary)
                        Spacer()
                        Image(systemName: "arrow.right")
                            .font(AppTheme.Typography.title3)
                    }
                }
                .foregroundColor(isFormValid ? AppTheme.Colors.background : AppTheme.Colors.tertiaryText)
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.lg)
                .background(isFormValid ? AppTheme.Colors.brandPrimary : AppTheme.Colors.fillColor)
                .cornerRadius(AppTheme.CornerRadius.round)
            }
            .disabled(!isFormValid || isLoading)
            
            // Botón para crear cuenta
            HStack {
                Text("¿No tienes una cuenta?")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                Button("Regístrate") {
                    onSignUp()
                }
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.Colors.brandPrimary)
                .fontWeight(.semibold)
            }
            
            // Separador
            HStack {
                Rectangle()
                    .fill(AppTheme.Colors.separatorColor)
                    .frame(height: 1)
                
                Text("o")
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .padding(.horizontal, AppTheme.Spacing.md)
                
                Rectangle()
                    .fill(AppTheme.Colors.separatorColor)
                    .frame(height: 1)
            }
            .padding(.vertical, AppTheme.Spacing.lg)
            
            // Botón de acceso rápido para demo
            Button("Acceso Rápido (Demo)") {
                onQuickAccess()
            }
            .font(AppTheme.Typography.subheadline)
            .foregroundColor(AppTheme.Colors.brandPrimary)
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(AppTheme.Colors.brandPrimary.opacity(0.1))
            .cornerRadius(AppTheme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(AppTheme.Colors.brandPrimary, lineWidth: 1)
            )
        }
    }
    
    private var alternativeLoginSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Separador con texto
            HStack {
                Rectangle()
                    .fill(AppTheme.Colors.separatorColor)
                    .frame(height: 1)
                
                Text("O continúa con")
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .padding(.horizontal, AppTheme.Spacing.md)
                
                Rectangle()
                    .fill(AppTheme.Colors.separatorColor)
                    .frame(height: 1)
            }
            
            // Botones de login social
            VStack(spacing: AppTheme.Spacing.md) {
                // Simular login con Apple
                SocialLoginButton(
                    icon: "applelogo",
                    title: "Continuar con Apple",
                    backgroundColor: AppTheme.Colors.primaryText,
                    foregroundColor: AppTheme.Colors.background
                ) {
                    // Simular login con Apple
                    simulateLogin(method: "Apple")
                }
                
                // Simular login con Google
                SocialLoginButton(
                    icon: "globe",
                    title: "Continuar con Google",
                    backgroundColor: AppTheme.Colors.fillColor,
                    foregroundColor: AppTheme.Colors.primaryText
                ) {
                    // Simular login con Google
                    simulateLogin(method: "Google")
                }
            }
        }
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }
    
    // MARK: - Helper Properties
    private var isFormValid: Bool {
        !email.isEmpty && email.contains("@") && !password.isEmpty && password.count >= 6
    }
    
    // MARK: - Helper Functions
    private func performLogin() {
        guard isFormValid else { return }
        
        isLoading = true
        clearError()
        
        // Simular autenticación
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            
            // Simular diferentes escenarios
            if email.lowercased() == "error@test.com" {
                showError("Credenciales incorrectas. Verifica tu email y contraseña.")
            } else {
                onLoginComplete()
            }
        }
    }
    
    private func simulateLogin(method: String) {
        isLoading = true
        clearError()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
            onLoginComplete()
        }
    }
    
    private func showError(_ message: String) {
        errorMessage = message
        showingError = true
    }
    
    private func clearError() {
        showingError = false
        errorMessage = ""
    }
    
    private func loadExampleData() {
        email = "jhon.miranda@proyectox.com"
        password = "123456789"
        clearError()
    }
}

// MARK: - Supporting Components
struct SocialLoginButton: View {
    let icon: String
    let title: String
    let backgroundColor: Color
    let foregroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: icon)
                    .font(AppTheme.Typography.title3)
                
                Text(title)
                    .font(AppTheme.Typography.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
            }
            .foregroundColor(foregroundColor)
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(backgroundColor)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(AppTheme.Colors.separatorColor, lineWidth: 1)
            )
        }
    }
}

// MARK: - Forgot Password View
struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = ""
    @State private var isLoading = false
    @State private var emailSent = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: AppTheme.Spacing.xxl) {
                // Header
                VStack(spacing: AppTheme.Spacing.lg) {
                    Image(systemName: emailSent ? "checkmark.circle.fill" : "key.fill")
                        .font(.system(size: 60))
                        .foregroundColor(emailSent ? AppTheme.Colors.success : AppTheme.Colors.brandPrimary)
                    
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text(emailSent ? "Email Enviado" : "Recuperar Contraseña")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        Text(emailSent ? 
                             "Revisa tu bandeja de entrada y sigue las instrucciones para restablecer tu contraseña." :
                             "Ingresa tu email y te enviaremos las instrucciones para recuperar tu contraseña."
                        )
                        .font(AppTheme.Typography.body)
                        .foregroundColor(AppTheme.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                        .lineSpacing(2)
                    }
                }
                .padding(.top, AppTheme.Spacing.xl)
                
                if !emailSent {
                    // Formulario
                    VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
                        Text("Email")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        TextField("ejemplo@correo.com", text: $email)
                            .font(AppTheme.Typography.body)
                            .foregroundColor(AppTheme.Colors.primaryText)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding(.horizontal, AppTheme.Spacing.md)
                            .padding(.vertical, AppTheme.Spacing.sm)
                            .background(AppTheme.Colors.fillColor)
                            .cornerRadius(AppTheme.CornerRadius.small)
                    }
                    .padding(AppTheme.Spacing.lg)
                    .background(AppTheme.Colors.cardBackground)
                    .cornerRadius(AppTheme.CornerRadius.large)
                    
                    // Botón de envío
                    Button(action: sendResetEmail) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: AppTheme.Colors.background))
                                    .scaleEffect(0.8)
                            } else {
                                Text("Enviar Instrucciones")
                                    .font(AppTheme.Typography.buttonPrimary)
                                Spacer()
                                Image(systemName: "arrow.right")
                                    .font(AppTheme.Typography.title3)
                            }
                        }
                        .foregroundColor(email.contains("@") ? AppTheme.Colors.background : AppTheme.Colors.tertiaryText)
                        .padding(.horizontal, AppTheme.Spacing.xl)
                        .padding(.vertical, AppTheme.Spacing.lg)
                        .background(email.contains("@") ? AppTheme.Colors.brandPrimary : AppTheme.Colors.fillColor)
                        .cornerRadius(AppTheme.CornerRadius.round)
                    }
                    .disabled(!email.contains("@") || isLoading)
                } else {
                    // Botón para cerrar después del envío
                    Button("Entendido") {
                        dismiss()
                    }
                    .font(AppTheme.Typography.buttonPrimary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, AppTheme.Spacing.lg)
                    .background(AppTheme.Colors.brandPrimary)
                    .foregroundColor(AppTheme.Colors.background)
                    .cornerRadius(AppTheme.CornerRadius.round)
                }
                
                Spacer()
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.vertical, AppTheme.Spacing.lg)
            .navigationTitle("Recuperar Contraseña")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                }
            }
            .background(AppTheme.Colors.groupedBackground)
        }
    }
    
    private func sendResetEmail() {
        isLoading = true
        
        // Simular envío de email
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            emailSent = true
        }
    }
}

// MARK: - Login Fields Enum
enum LoginField: CaseIterable {
    case email, password
}

#Preview {
    LegacyLoginView(
        onLoginComplete: { print("Login completed") },
        onBack: { print("Back pressed") },
        onSignUp: { print("Sign up pressed") },
        onQuickAccess: { print("Quick access pressed") }
    )
}