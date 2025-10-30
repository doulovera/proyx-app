import SwiftUI

struct PersonalInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email = "jhon.miranda@email.com"
    @State private var phone = "+1 (555) 123-4567"
    @State private var streetAddress1 = "Calle Principal 123, Apt 4B"
    @State private var streetAddress2 = ""
    @State private var city = "Ciudad de México"
    @State private var state = "CDMX"
    @State private var country = "México"
    @State private var postalCode = "01234"
    
    // Datos no editables
    private let fullName = "Jhon Miranda"
    private let dni = "12345678"
    private let memberSince = "Julio 2025"
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xxl) {
                    headerSection
                    personalInfoSection
                    contactInfoSection
                    addressSection
                    saveButtonSection
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.lg)
            }
            .navigationTitle("Información Personal")
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
    
    private var headerSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
            Text("Todos los campos son requeridos a menos que se indique lo contrario.")
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text("Para cambiar tu nombre o DNI, por favor contacta a soporte en +1 800 627 7468")
                .font(AppTheme.Typography.subheadline)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, AppTheme.Spacing.md)
    }
    
    private var personalInfoSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Nombre (No editable)
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("NOMBRE COMPLETO")
                    .font(AppTheme.Typography.caption1)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                HStack {
                    Text(fullName)
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "lock.fill")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.vertical, AppTheme.Spacing.md)
                .background(AppTheme.Colors.fillColor)
                .cornerRadius(AppTheme.CornerRadius.small)
            }
            
            // DNI (No editable)
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("DOCUMENTO DE IDENTIDAD")
                    .font(AppTheme.Typography.caption1)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                HStack {
                    Text(dni)
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "lock.fill")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.vertical, AppTheme.Spacing.md)
                .background(AppTheme.Colors.fillColor)
                .cornerRadius(AppTheme.CornerRadius.small)
            }
            
            // Miembro desde (No editable)
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("MIEMBRO DESDE")
                    .font(AppTheme.Typography.caption1)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                HStack {
                    Text(memberSince)
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image(systemName: "calendar")
                        .font(AppTheme.Typography.caption1)
                        .foregroundColor(AppTheme.Colors.tertiaryText)
                }
                .padding(.horizontal, AppTheme.Spacing.lg)
                .padding(.vertical, AppTheme.Spacing.md)
                .background(AppTheme.Colors.fillColor)
                .cornerRadius(AppTheme.CornerRadius.small)
            }
        }
    }
    
    private var contactInfoSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Email
            EditableField(
                label: "CORREO ELECTRÓNICO",
                text: $email,
                placeholder: "tu@email.com",
                keyboardType: .emailAddress
            )
            
            // Teléfono
            EditableField(
                label: "TELÉFONO",
                text: $phone,
                placeholder: "+1 (555) 123-4567",
                keyboardType: .phonePad
            )
        }
    }
    
    private var addressSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Dirección línea 1
            EditableField(
                label: "DIRECCIÓN LÍNEA 1",
                text: $streetAddress1,
                placeholder: "Calle Principal 123"
            )
            
            // Dirección línea 2 (Opcional)
            EditableField(
                label: "DIRECCIÓN LÍNEA 2 (OPCIONAL)",
                text: $streetAddress2,
                placeholder: "Apartamento, suite, etc.",
                isOptional: true
            )
            
            // Ciudad
            EditableField(
                label: "CIUDAD",
                text: $city,
                placeholder: "Ciudad"
            )
            
            // Estado/Provincia
            EditableField(
                label: "ESTADO/PROVINCIA",
                text: $state,
                placeholder: "Estado o Provincia"
            )
            
            // País
            EditableField(
                label: "PAÍS/REGIÓN",
                text: $country,
                placeholder: "País"
            )
            
            // Código Postal
            EditableField(
                label: "CÓDIGO POSTAL",
                text: $postalCode,
                placeholder: "12345",
                keyboardType: .numberPad
            )
        }
    }
    
    private var saveButtonSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Button("Guardar") {
                // Simular guardado
                dismiss()
            }
            .font(AppTheme.Typography.buttonPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.lg)
            .background(AppTheme.Colors.primaryText)
            .foregroundColor(AppTheme.Colors.background)
            .cornerRadius(AppTheme.CornerRadius.round)
            
            Text("Los cambios se guardarán automáticamente")
                .font(AppTheme.Typography.caption1)
                .foregroundColor(AppTheme.Colors.tertiaryText)
                .multilineTextAlignment(.center)
        }
        .padding(.top, AppTheme.Spacing.xl)
        .padding(.bottom, AppTheme.Spacing.xxxl)
    }
}

// MARK: - EditableField Component
struct EditableField: View {
    let label: String
    @Binding var text: String
    let placeholder: String
    var keyboardType: UIKeyboardType = .default
    var isOptional: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
            Text(label)
                .font(AppTheme.Typography.caption1)
                .fontWeight(.semibold)
                .foregroundColor(AppTheme.Colors.secondaryText)
            
            HStack {
                TextField(placeholder, text: $text)
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(AppTheme.Typography.subheadline)
                            .foregroundColor(AppTheme.Colors.tertiaryText)
                    }
                }
            }
            .padding(.horizontal, AppTheme.Spacing.lg)
            .padding(.vertical, AppTheme.Spacing.md)
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.small)
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.small)
                    .stroke(
                        text.isEmpty && !isOptional 
                        ? AppTheme.Colors.error.opacity(0.3) 
                        : AppTheme.Colors.separatorColor,
                        lineWidth: 1
                    )
            )
            
            if text.isEmpty && !isOptional {
                Text("Este campo es requerido")
                    .font(AppTheme.Typography.caption2)
                    .foregroundColor(AppTheme.Colors.error)
            }
        }
    }
}

#Preview {
    PersonalInfoView()
}