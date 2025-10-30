import SwiftUI

struct LoginViewBackend: View {
    @ObservedObject private var networkManager = NetworkManager.shared
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var showingSignUp = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    // Header
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text("¡Bienvenido de nuevo!")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        Text("Inicia sesión para continuar")
                            .bodyText()
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                    .padding(.top, AppTheme.Spacing.xl)
                    
                    // Login form
                    VStack(spacing: AppTheme.Spacing.lg) {
                        // Email field
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text("Email")
                                .captionText()
                                .fontWeight(.medium)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            
                            TextField("tu@email.com", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        // Password field
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text("Contraseña")
                                .captionText()
                                .fontWeight(.medium)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            
                            SecureField("Tu contraseña", text: $password)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.password)
                        }
                        
                        // Login button
                        Button(action: loginAction) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("Iniciar Sesión")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppTheme.Colors.brandPrimary)
                            .foregroundColor(AppTheme.Colors.background)
                            .cornerRadius(AppTheme.CornerRadius.medium)
                        }
                        .disabled(isLoading || email.isEmpty || password.isEmpty)
                        .opacity(email.isEmpty || password.isEmpty ? 0.6 : 1.0)
                    }
                    
                    // Quick login for testing
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text("Cuentas de prueba:")
                            .captionText()
                            .fontWeight(.medium)
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        
                        VStack(spacing: AppTheme.Spacing.xs) {
                            quickLoginButton(email: "admin@proyectox.com", label: "Admin (Platinum)", color: .purple)
                            quickLoginButton(email: "maria.garcia@email.com", label: "María (Gold)", color: .yellow)
                            quickLoginButton(email: "carlos.lopez@email.com", label: "Carlos (Silver)", color: .gray)
                        }
                    }
                    .padding(.top, AppTheme.Spacing.md)
                    
                    // Sign up link
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text("¿No tienes cuenta?")
                            .captionText()
                            .foregroundColor(AppTheme.Colors.secondaryText)
                        
                        Button("Crear cuenta") {
                            showingSignUp = true
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(AppTheme.Colors.accent)
                    }
                    .padding(.top, AppTheme.Spacing.md)
                    
                    Spacer(minLength: AppTheme.Spacing.xl)
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
            }
            .background(AppTheme.Colors.background)
            .navigationBarHidden(true)
        }
        .alert("Error de inicio de sesión", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .sheet(isPresented: $showingSignUp) {
            SignUpViewBackend()
        }
    }
    
    private func quickLoginButton(email: String, label: String, color: Color) -> some View {
        Button(action: {
            self.email = email
            self.password = "password123"
            loginAction()
        }) {
            HStack {
                Circle()
                    .fill(color)
                    .frame(width: 8, height: 8)
                Text(label)
                    .captionText()
                Spacer()
                Text("password123")
                    .font(.caption2)
                    .foregroundColor(AppTheme.Colors.secondaryText)
            }
            .padding(.horizontal, AppTheme.Spacing.sm)
            .padding(.vertical, AppTheme.Spacing.xs)
            .background(AppTheme.Colors.fillColor.opacity(0.5))
            .cornerRadius(AppTheme.CornerRadius.small)
        }
        .foregroundColor(AppTheme.Colors.primaryText)
    }
    
    private func loginAction() {
        guard !email.isEmpty && !password.isEmpty else { return }
        
        isLoading = true
        
        Task {
            do {
                _ = try await networkManager.login(email: email, password: password)
                await MainActor.run {
                    isLoading = false
                    // Login successful, NetworkManager will update isLoggedIn
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        }
    }
}

struct SignUpViewBackend: View {
    let onSignUpComplete: (() -> Void)?
    let onBack: (() -> Void)?
    let onLogin: (() -> Void)?
    
    @ObservedObject private var networkManager = NetworkManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    // Constructor por defecto para uso independiente
    init(onSignUpComplete: (() -> Void)? = nil, onBack: (() -> Void)? = nil, onLogin: (() -> Void)? = nil) {
        self.onSignUpComplete = onSignUpComplete
        self.onBack = onBack
        self.onLogin = onLogin
    }
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var phone = ""
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.lg) {
                    // Header
                    VStack(spacing: AppTheme.Spacing.sm) {
                        Text("Crear cuenta")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        Text("Únete a Proyecto X SaaS")
                            .bodyText()
                            .foregroundColor(AppTheme.Colors.secondaryText)
                    }
                    .padding(.top, AppTheme.Spacing.lg)
                    
                    // Sign up form
                    VStack(spacing: AppTheme.Spacing.md) {
                        // Name fields
                        HStack(spacing: AppTheme.Spacing.sm) {
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                                Text("Nombre")
                                    .captionText()
                                    .fontWeight(.medium)
                                
                                TextField("Nombre", text: $firstName)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .textContentType(.givenName)
                            }
                            
                            VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                                Text("Apellido")
                                    .captionText()
                                    .fontWeight(.medium)
                                
                                TextField("Apellido", text: $lastName)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .textContentType(.familyName)
                            }
                        }
                        
                        // Email field
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text("Email")
                                .captionText()
                                .fontWeight(.medium)
                            
                            TextField("tu@email.com", text: $email)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                        }
                        
                        // Phone field
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text("Teléfono (opcional)")
                                .captionText()
                                .fontWeight(.medium)
                            
                            TextField("+34 123 456 789", text: $phone)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.telephoneNumber)
                                .keyboardType(.phonePad)
                        }
                        
                        // Password fields
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text("Contraseña")
                                .captionText()
                                .fontWeight(.medium)
                            
                            SecureField("Contraseña", text: $password)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.newPassword)
                        }
                        
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                            Text("Confirmar contraseña")
                                .captionText()
                                .fontWeight(.medium)
                            
                            SecureField("Confirmar contraseña", text: $confirmPassword)
                                .textFieldStyle(CustomTextFieldStyle())
                                .textContentType(.newPassword)
                        }
                        
                        if !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword {
                            Text("Las contraseñas no coinciden")
                                .captionText()
                                .foregroundColor(.red)
                        }
                    }
                    
                    // Sign up button
                    Button(action: signUpAction) {
                        HStack {
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Crear Cuenta")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppTheme.Colors.brandPrimary)
                        .foregroundColor(AppTheme.Colors.background)
                        .cornerRadius(AppTheme.CornerRadius.medium)
                    }
                    .disabled(isLoading || !isFormValid)
                    .opacity(isFormValid ? 1.0 : 0.6)
                    
                    Spacer(minLength: AppTheme.Spacing.xl)
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
            }
            .background(AppTheme.Colors.background)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        .alert("Error de registro", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private var isFormValid: Bool {
        !email.isEmpty &&
        !password.isEmpty &&
        !confirmPassword.isEmpty &&
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        password == confirmPassword &&
        password.count >= 6
    }
    
    private func signUpAction() {
        guard isFormValid else { return }
        
        isLoading = true
        
        Task {
            do {
                _ = try await networkManager.register(
                    email: email,
                    password: password,
                    confirmPassword: confirmPassword,
                    firstName: firstName,
                    lastName: lastName,
                    phone: phone.isEmpty ? nil : phone
                )
                await MainActor.run {
                    isLoading = false
                    if let onSignUpComplete = onSignUpComplete {
                        onSignUpComplete()
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = error.localizedDescription
                    showingAlert = true
                }
            }
        }
    }
}

// Custom text field style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(AppTheme.Colors.fillColor)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                    .stroke(AppTheme.Colors.separatorColor, lineWidth: 1)
            )
    }
}

#Preview {
    LoginViewBackend()
}
