import SwiftUI

struct TermsAndConditionsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0
    
    private let tabs = ["Términos", "Privacidad"]
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Selector de tabs
                tabSelector
                
                // Contenido
                TabView(selection: $selectedTab) {
                    termsContent
                        .tag(0)
                    
                    privacyContent
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
            .navigationTitle("Términos Legales")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cerrar") {
                        dismiss()
                    }
                    .font(AppTheme.Typography.subheadline)
                    .foregroundColor(AppTheme.Colors.brandPrimary)
                }
            }
            .background(AppTheme.Colors.groupedBackground)
        }
    }
    
    private var tabSelector: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = index
                    }
                }) {
                    Text(tabs[index])
                        .font(AppTheme.Typography.subheadline)
                        .foregroundColor(selectedTab == index ? AppTheme.Colors.brandPrimary : AppTheme.Colors.secondaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, AppTheme.Spacing.md)
                        .background(
                            Rectangle()
                                .fill(selectedTab == index ? AppTheme.Colors.brandPrimary.opacity(0.1) : Color.clear)
                        )
                }
            }
        }
        .background(AppTheme.Colors.cardBackground)
        .overlay(
            Rectangle()
                .fill(AppTheme.Colors.separatorColor)
                .frame(height: 0.5),
            alignment: .bottom
        )
    }
    
    private var termsContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                sectionCard(
                    title: "1. Aceptación de Términos",
                    content: """
                    Al acceder y utilizar la aplicación Proyecto X, usted acepta estar legalmente vinculado por estos términos y condiciones de uso. Si no está de acuerdo con alguno de estos términos, no debe utilizar esta aplicación.
                    
                    Estos términos constituyen un acuerdo legal entre usted y Proyecto X. Nos reservamos el derecho de modificar estos términos en cualquier momento sin previo aviso.
                    """
                )
                
                sectionCard(
                    title: "2. Descripción del Servicio",
                    content: """
                    Proyecto X es una plataforma digital que conecta a usuarios con comercios locales, permitiendo:
                    
                    • Navegación y compra de productos locales
                    • Participación en eventos gastronómicos
                    • Sistema de puntos y recompensas
                    • Descubrimiento de nuevas experiencias culinarias
                    
                    El servicio está sujeto a disponibilidad y puede variar según la ubicación geográfica.
                    """
                )
                
                sectionCard(
                    title: "3. Cuenta de Usuario",
                    content: """
                    Para utilizar ciertos servicios, debe crear una cuenta proporcionando información precisa y completa. Usted es responsable de:
                    
                    • Mantener la confidencialidad de sus credenciales
                    • Todas las actividades que ocurran bajo su cuenta
                    • Notificar inmediatamente cualquier uso no autorizado
                    
                    Nos reservamos el derecho de suspender o terminar cuentas que violen estos términos.
                    """
                )
                
                sectionCard(
                    title: "4. Sistema de Puntos",
                    content: """
                    Nuestro sistema de puntos permite acumular recompensas por compras y participación. Los puntos:
                    
                    • No tienen valor monetario
                    • No son transferibles entre usuarios
                    • Pueden expirar según las políticas vigentes
                    • Están sujetos a términos específicos del programa
                    
                    Nos reservamos el derecho de modificar el programa de puntos con previo aviso.
                    """
                )
                
                sectionCard(
                    title: "5. Uso Aceptable",
                    content: """
                    Usted se compromete a no utilizar la aplicación para:
                    
                    • Actividades ilegales o fraudulentas
                    • Envío de contenido ofensivo o inapropiado
                    • Interferir con el funcionamiento del servicio
                    • Intentar acceder a sistemas no autorizados
                    
                    Cualquier violación puede resultar en la terminación inmediata de su cuenta.
                    """
                )
                
                sectionCard(
                    title: "6. Limitación de Responsabilidad",
                    content: """
                    Proyecto X no será responsable de daños indirectos, incidentales o consecuentes que surjan del uso de la aplicación. Nuestra responsabilidad total no excederá el monto pagado por los servicios en los últimos 12 meses.
                    
                    Los productos y servicios de terceros están sujetos a sus propios términos y condiciones.
                    """
                )
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.vertical, AppTheme.Spacing.lg)
        }
    }
    
    private var privacyContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: AppTheme.Spacing.xl) {
                sectionCard(
                    title: "Recopilación de Información",
                    content: """
                    Recopilamos información que usted nos proporciona directamente, incluyendo:
                    
                    • Información de registro (nombre, email, teléfono)
                    • Preferencias alimentarias y dietéticas
                    • Historial de compras y puntos
                    • Comentarios y calificaciones
                    
                    También recopilamos información automáticamente sobre el uso de la aplicación.
                    """
                )
                
                sectionCard(
                    title: "Uso de la Información",
                    content: """
                    Utilizamos su información personal para:
                    
                    • Proporcionar y mejorar nuestros servicios
                    • Procesar transacciones y gestionar su cuenta
                    • Enviar notificaciones sobre pedidos y ofertas
                    • Personalizar su experiencia en la aplicación
                    • Cumplir con obligaciones legales
                    
                    No vendemos ni compartimos su información personal con terceros sin su consentimiento.
                    """
                )
                
                sectionCard(
                    title: "Protección de Datos",
                    content: """
                    Implementamos medidas de seguridad técnicas y organizativas para proteger su información:
                    
                    • Cifrado de datos sensibles
                    • Acceso limitado a información personal
                    • Monitoreo continuo de seguridad
                    • Auditorías regulares de sistemas
                    
                    Sin embargo, ningún método de transmisión por internet es 100% seguro.
                    """
                )
                
                sectionCard(
                    title: "Sus Derechos",
                    content: """
                    Usted tiene derecho a:
                    
                    • Acceder a su información personal
                    • Corregir datos inexactos
                    • Solicitar la eliminación de datos
                    • Restringir el procesamiento
                    • Retirar el consentimiento en cualquier momento
                    
                    Para ejercer estos derechos, contáctenos a través de la aplicación.
                    """
                )
                
                sectionCard(
                    title: "Cookies y Tecnologías Similares",
                    content: """
                    Utilizamos cookies y tecnologías similares para:
                    
                    • Recordar sus preferencias
                    • Analizar el uso de la aplicación
                    • Personalizar contenido y anuncios
                    • Mejorar la funcionalidad
                    
                    Puede gestionar las preferencias de cookies en la configuración de su dispositivo.
                    """
                )
                
                sectionCard(
                    title: "Cambios en la Política",
                    content: """
                    Podemos actualizar esta política de privacidad ocasionalmente. Los cambios importantes serán notificados a través de:
                    
                    • Notificación en la aplicación
                    • Email a su dirección registrada
                    • Aviso en esta página
                    
                    Le recomendamos revisar esta política periódicamente.
                    """
                )
            }
            .padding(.horizontal, AppTheme.Spacing.xl)
            .padding(.vertical, AppTheme.Spacing.lg)
        }
    }
    
    private func sectionCard(title: String, content: String) -> some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.md) {
            Text(title)
                .font(AppTheme.Typography.headline)
                .foregroundColor(AppTheme.Colors.primaryText)
            
            Text(content)
                .font(AppTheme.Typography.body)
                .foregroundColor(AppTheme.Colors.secondaryText)
                .lineSpacing(2)
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.cardBackground)
        .cornerRadius(AppTheme.CornerRadius.large)
    }
}

#Preview {
    TermsAndConditionsView()
}