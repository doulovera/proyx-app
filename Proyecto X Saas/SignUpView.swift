import SwiftUI

struct SignUpView: View {
    let onSignUpComplete: () -> Void
    let onBack: () -> Void
    let onLogin: () -> Void
    
    @State private var fullName = ""
    @State private var email = ""
    @State private var phoneNumber = ""
    @State private var dni = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var address = ""
    @State private var city = "Lima"
    @State private var state = "Lima"
    @State private var acceptTerms = false
    @State private var receiveNotifications = true
    
    @State private var showingTerms = false
    @State private var isFormValid = false
    @State private var showingErrors = false
    @FocusState private var focusedField: FormField?
    
    private let cities = ["Caracas", "Maracaibo", "Valencia", "Barquisimeto", "Maracay", "Ciudad Guayana"]
    private let states = ["Distrito Capital", "Zulia", "Carabobo", "Lara", "Aragua", "Bolívar"]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xxl) {
                    headerSection
                    formSection
                    termsSection
                    actionButtonsSection
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
            .sheet(isPresented: $showingTerms) {
                TermsAndConditionsView()
            }
        }
        .onChange(of: fullName) { validateForm() }
        .onChange(of: email) { validateForm() }
        .onChange(of: phoneNumber) { validateForm() }
        .onChange(of: dni) { validateForm() }
        .onChange(of: password) { validateForm() }
        .onChange(of: confirmPassword) { validateForm() }
        .onChange(of: address) { validateForm() }
        .onChange(of: acceptTerms) { validateForm() }
    }
    
    private var headerSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Image(systemName: "person.badge.plus.fill")
                .font(.system(size: 50))
                .foregroundColor(AppTheme.Colors.brandPrimary)
            
            VStack(spacing: AppTheme.Spacing.sm) {
                Text("Crear Cuenta")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text("Únete a nuestra comunidad local")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                
                Button("Rellenar con datos de ejemplo") {
                    loadExampleData()
                }
                .font(AppTheme.Typography.caption1)
                .foregroundColor(AppTheme.Colors.brandPrimary)
                .padding(.horizontal, AppTheme.Spacing.md)
                .padding(.vertical, AppTheme.Spacing.sm)
                .background(AppTheme.Colors.brandPrimary.opacity(0.1))
                .cornerRadius(AppTheme.CornerRadius.medium)
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium)
                        .stroke(AppTheme.Colors.brandPrimary, lineWidth: 1)
                )
                .padding(.top, AppTheme.Spacing.sm)
            }
        }
        .padding(.top, AppTheme.Spacing.lg)
    }
    
    private var formSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Información personal
            sectionCard(title: "Información Personal") {
                VStack(spacing: AppTheme.Spacing.md) {
                    FormTextField(
                        title: "Nombre Completo",
                        text: $fullName,
                        placeholder: "Ingresa tu nombre completo",
                        keyboardType: .default
                    )
                    .focused($focusedField, equals: .fullName)
                    
                    FormTextField(
                        title: "Correo Electrónico",
                        text: $email,
                        placeholder: "ejemplo@correo.com",
                        keyboardType: .emailAddress
                    )
                    .focused($focusedField, equals: .email)
                    
                    FormTextField(
                        title: "Teléfono",
                        text: $phoneNumber,
                        placeholder: "+58 414 123 4567",
                        keyboardType: .phonePad
                    )
                    .focused($focusedField, equals: .phone)
                    
                    FormTextField(
                        title: "DNI",
                        text: $dni,
                        placeholder: "12345678",
                        keyboardType: .numberPad
                    )
                    .focused($focusedField, equals: .dni)
                }
            }
            
            // Ubicación
            sectionCard(title: "Ubicación") {
                VStack(spacing: AppTheme.Spacing.md) {
                    FormTextField(
                        title: "Dirección",
                        text: $address,
                        placeholder: "Calle, urbanización, ciudad",
                        keyboardType: .default,
                        axis: .vertical
                    )
                    .focused($focusedField, equals: .address)
                    
                    HStack(spacing: AppTheme.Spacing.md) {
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("Ciudad")
                                .font(AppTheme.Typography.subheadline)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            
                            Picker("Ciudad", selection: $city) {
                                ForEach(cities, id: \.self) { city in
                                    Text(city).tag(city)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppTheme.Spacing.sm)
                            .background(AppTheme.Colors.fillColor)
                            .cornerRadius(AppTheme.CornerRadius.small)
                        }
                        
                        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                            Text("Estado")
                                .font(AppTheme.Typography.subheadline)
                                .foregroundColor(AppTheme.Colors.primaryText)
                            
                            Picker("Estado", selection: $state) {
                                ForEach(states, id: \.self) { state in
                                    Text(state).tag(state)
                                }
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, AppTheme.Spacing.sm)
                            .background(AppTheme.Colors.fillColor)
                            .cornerRadius(AppTheme.CornerRadius.small)
                        }
                    }
                }
            }
            
            // Seguridad
            sectionCard(title: "Seguridad") {
                VStack(spacing: AppTheme.Spacing.md) {
                    FormTextField(
                        title: "Contraseña",
                        text: $password,
                        placeholder: "Mínimo 8 caracteres",
                        isSecure: true
                    )
                    .focused($focusedField, equals: .password)
                    
                    FormTextField(
                        title: "Confirmar Contraseña",
                        text: $confirmPassword,
                        placeholder: "Repite tu contraseña",
                        isSecure: true
                    )
                    .focused($focusedField, equals: .confirmPassword)
                    
                    // Indicador de fortaleza de contraseña
                    if !password.isEmpty {
                        passwordStrengthIndicator
                    }
                }
            }
        }
    }
    
    private var passwordStrengthIndicator: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
            Text("Fortaleza de la contraseña")
                .font(AppTheme.Typography.caption1)
                .foregroundColor(AppTheme.Colors.secondaryText)
            
            HStack(spacing: AppTheme.Spacing.xs) {
                ForEach(0..<4, id: \.self) { index in
                    Rectangle()
                        .fill(passwordStrengthColor(index))
                        .frame(height: 4)
                        .cornerRadius(2)
                }
            }
            
            Text(passwordStrengthText)
                .font(AppTheme.Typography.caption2)
                .foregroundColor(passwordStrengthColor(0))
        }
    }
    
    private var termsSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            // Términos y condiciones
            HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                Button(action: {
                    acceptTerms.toggle()
                }) {
                    Image(systemName: acceptTerms ? "checkmark.square.fill" : "square")
                        .font(AppTheme.Typography.title3)
                        .foregroundColor(acceptTerms ? AppTheme.Colors.brandPrimary : AppTheme.Colors.tertiaryText)
                }
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    HStack {
                        Text("Acepto los ")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.primaryText)
                        
                        Button("Términos y Condiciones") {
                            showingTerms = true
                        }
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.brandPrimary)
                        .underline()
                        
                        Spacer()
                    }
                    
                    Text("* Campo obligatorio")
                        .font(AppTheme.Typography.caption2)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
            }
            
            // Notificaciones
            HStack(alignment: .top, spacing: AppTheme.Spacing.sm) {
                Button(action: {
                    receiveNotifications.toggle()
                }) {
                    Image(systemName: receiveNotifications ? "checkmark.square.fill" : "square")
                        .font(AppTheme.Typography.title3)
                        .foregroundColor(receiveNotifications ? AppTheme.Colors.brandPrimary : AppTheme.Colors.tertiaryText)
                }
                
                Text("Quiero recibir notificaciones sobre ofertas y eventos especiales")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    private var actionButtonsSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Button(action: {
                if isFormValid {
                    onSignUpComplete()
                } else {
                    showingErrors = true
                }
            }) {
                HStack {
                    Text("Crear Cuenta")
                        .font(AppTheme.Typography.buttonPrimary)
                    Spacer()
                    Image(systemName: "arrow.right")
                        .font(AppTheme.Typography.title3)
                }
                .foregroundColor(isFormValid ? AppTheme.Colors.background : AppTheme.Colors.tertiaryText)
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.lg)
                .background(isFormValid ? AppTheme.Colors.brandPrimary : AppTheme.Colors.fillColor)
                .cornerRadius(AppTheme.CornerRadius.round)
            }
            .disabled(!isFormValid)
            
            if showingErrors && !isFormValid {
                Text("Por favor completa todos los campos obligatorios")
                    .font(AppTheme.Typography.caption1)
                    .foregroundColor(AppTheme.Colors.error)
                    .padding(AppTheme.Spacing.sm)
                    .background(AppTheme.Colors.error.opacity(0.1))
                    .cornerRadius(AppTheme.CornerRadius.small)
            }
            
            // Botón para ir al login
            HStack {
                Text("¿Ya tienes una cuenta?")
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                Button("Inicia Sesión") {
                    onLogin()
                }
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.Colors.brandPrimary)
                .fontWeight(.semibold)
            }
        }
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }
    
    // MARK: - Helper Views
    private func sectionCard<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text(title)
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            content()
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
    
    // MARK: - Helper Functions
    private func validateForm() {
        let isPasswordValid = password.count >= 8 && password == confirmPassword
        let areFieldsFilled = !fullName.isEmpty && !email.isEmpty && !phoneNumber.isEmpty && 
                             !dni.isEmpty && !address.isEmpty && isPasswordValid
        
        isFormValid = areFieldsFilled && acceptTerms && email.contains("@")
    }
    
    private func passwordStrength() -> Int {
        var strength = 0
        if password.count >= 8 { strength += 1 }
        if password.rangeOfCharacter(from: .uppercaseLetters) != nil { strength += 1 }
        if password.rangeOfCharacter(from: .lowercaseLetters) != nil { strength += 1 }
        if password.rangeOfCharacter(from: .decimalDigits) != nil { strength += 1 }
        return strength
    }
    
    private func passwordStrengthColor(_ index: Int) -> Color {
        let strength = passwordStrength()
        if index < strength {
            switch strength {
            case 1: return AppTheme.Colors.error
            case 2: return AppTheme.Colors.warning
            case 3: return AppTheme.Colors.brandPrimary
            case 4: return AppTheme.Colors.success
            default: return AppTheme.Colors.tertiaryText
            }
        }
        return AppTheme.Colors.tertiaryText
    }
    
    private var passwordStrengthText: String {
        switch passwordStrength() {
        case 0...1: return "Débil"
        case 2: return "Regular"
        case 3: return "Buena"
        case 4: return "Excelente"
        default: return ""
        }
    }
    
    private func loadExampleData() {
        fullName = "Jhon Miranda"
        email = "jhon.miranda@proyectox.com"
        phoneNumber = "+51 987 654 321"
        dni = "12345678"
        password = "123456789"
        confirmPassword = "123456789"
        address = "Av. José Larco 123, Miraflores"
        city = "Lima"
        state = "Lima"
        acceptTerms = true
        receiveNotifications = true
        
        // Validar formulario después de cargar datos
        validateForm()
    }
}

// MARK: - Form Fields Enum
enum FormField: CaseIterable {
    case fullName, email, phone, dni, address, password, confirmPassword
}

// MARK: - Form TextField Component
struct FormTextField: View {
    let title: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var isSecure: Bool = false
    var axis: Axis = .horizontal
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(title)
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else if axis == .vertical {
                    TextField(placeholder, text: $text, axis: .vertical)
                        .lineLimit(2...4)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(AppTheme.Typography.body)
            .foregroundColor(AppTheme.Colors.primaryText)
            .padding(.horizontal, AppTheme.Spacing.md)
            .padding(.vertical, AppTheme.Spacing.sm)
            .background(AppTheme.Colors.fillColor)
            .cornerRadius(AppTheme.CornerRadius.small)
            .keyboardType(keyboardType)
        }
    }
}

#Preview {
    SignUpView(
        onSignUpComplete: { print("Sign up completed") },
        onBack: { print("Back pressed") },
        onLogin: { print("Login pressed") }
    )
}
