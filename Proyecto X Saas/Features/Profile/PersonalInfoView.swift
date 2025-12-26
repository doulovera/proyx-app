import SwiftUI

struct PersonalInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PersonalInfoViewModel
    
    init(profileService: ProfileService, sessionStore: SessionStore) {
        _viewModel = StateObject(wrappedValue: PersonalInfoViewModel(
            profileService: profileService,
            sessionStore: sessionStore
        ))
    }
    
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
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                }
            }
            .alert("Éxito", isPresented: .constant(viewModel.successMessage != nil)) {
                Button("OK") {
                    viewModel.successMessage = nil
                    dismiss()
                }
            } message: {
                if let successMessage = viewModel.successMessage {
                    Text(successMessage)
                }
            }
            .disabled(viewModel.isLoading)
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.2))
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: AppTheme.Spacing.sm) {
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
                    Text(viewModel.fullName)
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
                    Text(viewModel.dni.isEmpty ? "No especificado" : viewModel.dni)
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
                    Text(viewModel.memberSince)
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
            // Email (No editable)
            VStack(alignment: .leading, spacing: AppTheme.Spacing.sm) {
                Text("CORREO ELECTRÓNICO")
                    .font(AppTheme.Typography.caption1)
                    .fontWeight(.semibold)
                    .foregroundColor(AppTheme.Colors.secondaryText)
                
                HStack {
                    Text(viewModel.email)
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
            
            Text("Para cambiar tu email, contacta a soporte")
                .font(AppTheme.Typography.caption2)
                .foregroundColor(AppTheme.Colors.tertiaryText)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            // Teléfono (Editable)
            EditableField(
                label: "TELÉFONO (OPCIONAL)",
                text: $viewModel.phone,
                placeholder: "+1 (555) 123-4567",
                keyboardType: .phonePad,
                isOptional: true
            )
        }
    }
    
    private var addressSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Dirección (Editable)
            EditableField(
                label: "DIRECCIÓN (OPCIONAL)",
                text: $viewModel.address,
                placeholder: "Calle Principal 123, Apt 4B",
                isOptional: true
            )
            
            // Código Postal (Editable)
            EditableField(
                label: "CÓDIGO POSTAL (OPCIONAL)",
                text: $viewModel.zipCode,
                placeholder: "12345",
                keyboardType: .numberPad,
                isOptional: true
            )
        }
    }
    
    private var saveButtonSection: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            Button("Guardar Cambios") {
                Task {
                    await viewModel.save()
                }
            }
            .font(AppTheme.Typography.buttonPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, AppTheme.Spacing.lg)
            .background(AppTheme.Colors.primaryText)
            .foregroundColor(AppTheme.Colors.background)
            .cornerRadius(AppTheme.CornerRadius.round)
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
    let sessionStore = SessionStore()
    let apiClient = APIClient(tokenProvider: { sessionStore.token })
    let profileService = ProfileService(client: apiClient)
    
    return PersonalInfoView(
        profileService: profileService,
        sessionStore: sessionStore
    )
}
