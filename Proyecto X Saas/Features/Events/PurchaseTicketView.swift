import SwiftUI

struct PurchaseTicketView: View {
    let event: Event
    let ticketCount: Int
    @Environment(\.dismiss) private var dismiss
    @State private var showingSuccessView = false
    @State private var selectedPaymentMethod: PaymentMethod = .card
    @State private var cardNumber = ""
    @State private var expiryDate = ""
    @State private var cvv = ""
    @State private var cardholderName = ""
    @State private var email = ""
    @State private var fullName = ""
    @State private var phone = ""
    
    var totalAmount: Int {
        return Int(event.price * Double(ticketCount))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    ticketSummarySection
                    paymentMethodSection
                    if selectedPaymentMethod == .card {
                        paymentDetailsSection
                    }
                    contactInfoSection
                    totalSection
                    purchaseButton
                }
                .padding(.horizontal, AppTheme.Spacing.xl)
                .padding(.vertical, AppTheme.Spacing.lg)
            }
            .navigationTitle("Comprar Entradas")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .background(AppTheme.Colors.groupedBackground)
        }
        .sheet(isPresented: $showingSuccessView) {
            PurchaseSuccessView(event: event, ticketCount: ticketCount)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(event.title)
                .font(AppTheme.Typography.title2)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Fecha")
                        .captionText()
                    Text(event.dateText)
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Hora")
                        .captionText()
                    Text(event.time ?? "-")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Ubicación")
                        .captionText()
                    Text(event.location ?? "-")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
    
    private var ticketSummarySection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Resumen de entradas")
                .sectionHeader()
            
            HStack {
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs) {
                    Text("Entrada General")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    Text("Acceso completo al evento")
                        .captionText()
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: AppTheme.Spacing.xs) {
                    Text("x\(ticketCount)")
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    Text("$\(Int(event.price)) c/u")
                        .captionText()
                }
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
    
    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text("Método de pago")
                .sectionHeader()
            
            VStack(spacing: AppTheme.Spacing.sm) {
                PaymentMethodRow(
                    method: .card,
                    selectedMethod: $selectedPaymentMethod,
                    icon: "creditcard.fill",
                    title: "Tarjeta de crédito/débito",
                    subtitle: "Visa, Mastercard, American Express"
                )
                
                PaymentMethodRow(
                    method: .applePay,
                    selectedMethod: $selectedPaymentMethod,
                    icon: "applepay",
                    title: "Apple Pay",
                    subtitle: "Pago rápido y seguro"
                )
                
                PaymentMethodRow(
                    method: .paypal,
                    selectedMethod: $selectedPaymentMethod,
                    icon: "dollarsign.circle.fill",
                    title: "PayPal",
                    subtitle: "Pago con tu cuenta PayPal"
                )
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
    
    private var paymentDetailsSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Detalles de la tarjeta")
                .sectionHeader()
            
            VStack(spacing: AppTheme.Spacing.md) {
                TextField("Número de tarjeta", text: $cardNumber)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                
                HStack(spacing: AppTheme.Spacing.md) {
                    TextField("MM/AA", text: $expiryDate)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    TextField("CVV", text: $cvv)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                
                TextField("Nombre del titular", text: $cardholderName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.name)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
    
    private var contactInfoSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.lg) {
            Text("Información de contacto")
                .sectionHeader()
            
            VStack(spacing: AppTheme.Spacing.md) {
                TextField("Nombre completo", text: $fullName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.name)
                
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                
                TextField("Teléfono", text: $phone)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.telephoneNumber)
                    .keyboardType(.phonePad)
            }
            
            Text("Recibirás tus entradas por email")
                .captionText()
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
    
    private var totalSection: some View {
        VStack(spacing: AppTheme.Spacing.md) {
            HStack {
                Text("Subtotal (\(ticketCount) entrada\(ticketCount > 1 ? "s" : ""))")
                    .bodyText()
                Spacer()
                Text("$\(totalAmount)")
                    .bodyText()
            }
            
            HStack {
                Text("Comisión de servicio")
                    .bodyText()
                Spacer()
                Text("$\(Int(Double(totalAmount) * 0.05))")
                    .bodyText()
            }
            
            Divider()
                .background(AppTheme.Colors.separatorColor)
            
            HStack {
                Text("Total")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                Spacer()
                Text("$\(totalAmount + Int(Double(totalAmount) * 0.05))")
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
            }
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.medium)
    }
    
    private var purchaseButton: some View {
        Button(action: {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                showingSuccessView = true
            }
        }) {
            HStack {
                if selectedPaymentMethod == .applePay {
                    Image(systemName: "applepay")
                        .font(AppTheme.Typography.title3)
                }
                Text(selectedPaymentMethod == .applePay ? "Pagar con Apple Pay" : "Confirmar compra")
                    .font(AppTheme.Typography.buttonPrimary)
            }
        }
        .buttonPrimaryStyle(isEnabled: isFormValid)
        .disabled(!isFormValid)
    }
    
    private var isFormValid: Bool {
        if selectedPaymentMethod == .card {
            return !cardNumber.isEmpty && !expiryDate.isEmpty && !cvv.isEmpty && 
                   !cardholderName.isEmpty && !email.isEmpty && !fullName.isEmpty && !phone.isEmpty
        } else {
            return !email.isEmpty && !fullName.isEmpty && !phone.isEmpty
        }
    }
}

enum PaymentMethod: CaseIterable {
    case card
    case applePay
    case paypal
}

struct PaymentMethodRow: View {
    let method: PaymentMethod
    @Binding var selectedMethod: PaymentMethod
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        Button(action: {
            selectedMethod = method
        }) {
            HStack(spacing: AppTheme.Spacing.md) {
                Image(systemName: icon)
                    .font(AppTheme.Typography.title3)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .frame(width: 24)
                
                VStack(alignment: .leading, spacing: AppTheme.Spacing.xs / 2) {
                    Text(title)
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(AppTheme.Colors.primaryText)
                    Text(subtitle)
                        .captionText()
                }
                
                Spacer()
                
                Circle()
                    .stroke(selectedMethod == method ? AppTheme.Colors.brandPrimary : AppTheme.Colors.secondaryText, lineWidth: 2)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .fill(selectedMethod == method ? AppTheme.Colors.brandPrimary : Color.clear)
                            .frame(width: 12, height: 12)
                    )
            }
            .padding(AppTheme.Spacing.lg)
            .background(AppTheme.Colors.fillColor.opacity(selectedMethod == method ? 1 : 0.3))
            .cornerRadius(AppTheme.CornerRadius.small)
        }
    }
}

struct PurchaseSuccessView: View {
    let event: Event
    let ticketCount: Int
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.xxl) {
            Spacer()
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(AppTheme.Colors.success)
            
            VStack(spacing: AppTheme.Spacing.md) {
                Text("¡Compra exitosa!")
                    .font(AppTheme.Typography.title1)
                    .foregroundColor(AppTheme.Colors.primaryText)
                
                Text("Has adquirido \(ticketCount) entrada\(ticketCount > 1 ? "s" : "") para")
                    .bodyText()
                    .multilineTextAlignment(.center)
                
                Text(event.title)
                    .font(AppTheme.Typography.headline)
                    .foregroundColor(AppTheme.Colors.primaryText)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: AppTheme.Spacing.sm) {
                Text("Tus entradas han sido enviadas a tu email")
                    .bodyText()
                    .multilineTextAlignment(.center)
                
                Text("Presenta tu código QR el día del evento")
                    .captionText()
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            VStack(spacing: AppTheme.Spacing.md) {
                Button("Ver mis entradas") {
                    
                }
                .buttonPrimaryStyle()
                
                Button("Continuar") {
                    dismiss()
                }
                .buttonSecondaryStyle()
            }
        }
        .padding(.horizontal, AppTheme.Spacing.xl)
        .padding(.vertical, AppTheme.Spacing.xxxl)
        .background(AppTheme.Colors.background)
    }
}

#Preview {
    PurchaseTicketView(
        event: Event(
            id: UUID(),
            title: "Noche de Sushi Premium",
            description: "Disfruta de la mejor selección de sushi artesanal",
            date: Date(),
            time: "7:00 PM",
            duration: "3 horas",
            location: "Restaurante Sakura",
            address: "Av. Principal 123",
            category: .gastronomico,
            price: 65,
            promoUnitPrice: nil,
            capacity: 25,
            availableTickets: 8,
            organizer: "Chef Hiroshi",
            requirements: ["Reserva previa"],
            includes: ["Menú completo"],
            tags: ["Premium"],
            isSponsored: true,
            imageURL: nil
        ),
        ticketCount: 2
    )
}
