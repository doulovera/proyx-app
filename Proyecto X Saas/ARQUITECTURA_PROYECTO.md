# 🏗️ Arquitectura del Proyecto - Proyecto X SaaS

**Fecha de reorganización**: 10 Agosto 2025
**Versión de arquitectura**: 2.0 Professional

---

## 📁 Estructura de Carpetas Profesional

```
Proyecto X Saas/
├── 📱 App/                          # Configuración principal de la app
│   ├── Proyecto_X_SaasApp.swift     # Entry point de la aplicación
│   └── AppCoordinator.swift         # Coordinador principal de navegación
│
├── 🏗️ Core/                         # Funcionalidades centrales y sistemas
│   ├── Networking/                  # Comunicación con el backend
│   │   └── NetworkManager.swift     # Manejo de API calls y autenticación JWT
│   ├── Models/                      # Modelos de datos del backend
│   │   └── BackendModels.swift      # Estructuras alineadas con la API
│   ├── Managers/                    # Managers de estado y datos
│   │   └── StoreManager.swift       # Gestión de stores, events y products
│   └── Theme/                       # Sistema de diseño
│       └── AppTheme.swift           # Colores, fuentes, espaciado centralizado
│
├── ⚡ Features/                      # Funcionalidades organizadas
│   ├── Backend/                     # 🟢 VISTAS ACTIVAS (Con integración real)
│   │   ├── Views/                   # Vistas principales del flujo
│   │   │   ├── ContentViewBackend.swift    # Vista principal con tabs
│   │   │   ├── HomeViewBackend.swift       # Dashboard principal
│   │   │   ├── LoginViewBackend.swift      # Autenticación JWT
│   │   │   ├── AllStoresViewBackend.swift  # Lista completa de tiendas
│   │   │   ├── AllEventsViewBackend.swift  # Lista completa de eventos
│   │   │   └── EventDetailView.swift       # Detalle de eventos
│   │   └── Components/              # Componentes reutilizables del backend
│   │       ├── BackendComponents.swift     # CategoryCard, EventRowBackend
│   │       ├── MemberCardView.swift        # Tarjeta de membresía
│   │       └── PurchaseTicketView.swift    # Compra de tickets
│   │
│   └── Legacy/                      # 🔴 VISTAS DESHABILITADAS (Mock/Obsoletas)
│       ├── README_LEGACY.md         # Documentación de vistas obsoletas
│       ├── ContentView.swift        # ❌ Vista principal original
│       ├── HomeView.swift           # ❌ Dashboard con datos mock
│       ├── LoginView.swift          # ❌ Login sin backend
│       ├── AllStoresView.swift      # ❌ Tiendas mock
│       ├── EventsView.swift         # ❌ Eventos mock
│       ├── ProductsView.swift       # ❌ Productos mock
│       ├── AllPromotionsView.swift  # ❌ Promociones mock
│       ├── ProfileView.swift        # ❌ Perfil mock
│       ├── Event.swift              # ❌ Modelo evento original
│       ├── Product.swift            # ❌ Modelo producto original
│       └── PromotionStore.swift     # ❌ Store promociones mock
│
├── 🚀 Onboarding/                   # Flujo de incorporación de usuarios
│   ├── OnboardingCoordinator.swift  # Coordinador del onboarding
│   ├── OnboardingWelcomeView.swift  # Pantalla de bienvenida
│   ├── OnboardingCompleteView.swift # Pantalla de finalización
│   ├── PersonalInfoView.swift       # Información personal
│   ├── PreferencesView.swift        # Preferencias del usuario
│   ├── SignUpView.swift             # Registro de usuario
│   ├── SplashView.swift             # Splash screen
│   └── TermsAndConditionsView.swift # Términos y condiciones
│
└── 📚 Resources/                    # Recursos y documentación
    ├── Assets.xcassets/             # Iconos, imágenes, colores
    └── INTEGRACION-iOS-BACKEND.md   # Documentación técnica completa
```

---

## 🎯 Flujo Principal de la Aplicación

### **1. Inicio de la App**
```
Proyecto_X_SaasApp.swift → ContentViewBackend.swift
```

### **2. Autenticación**
```
LoginViewBackend.swift → NetworkManager.login() → JWT Storage
```

### **3. Navegación Principal**
```
ContentViewBackend.swift (TabView)
├── HomeViewBackend.swift (Tab 1)
├── AllStoresViewBackend.swift (Tab 2)  
├── AllEventsViewBackend.swift (Tab 3)
├── ProductsTabView (Tab 4)
└── ProfileViewBackend (Tab 5)
```

---

## 🔧 Componentes Clave

### **Backend Integration Stack**
- **NetworkManager**: Comunicación con Railway API
- **BackendModels**: Modelos alineados con el backend
- **StoreManager**: Gestión de estado de datos
- **BackendComponents**: Componentes UI especializados

### **Datos Reales**
- **5 tiendas** de Madrid con coordenadas GPS
- **25 productos** con precios en euros
- **5 eventos gastronómicos** con fechas futuras
- **15 usuarios** con diferentes membresías
- **Autenticación JWT** completamente funcional

---

## 🚦 Estado de Archivos

### 🟢 **ACTIVOS** - Se usan en el flujo principal
- Todo en `Features/Backend/`
- Todo en `Core/`
- Todo en `App/`
- Todo en `Onboarding/`

### 🔴 **DESHABILITADOS** - NO se usan (Legacy)
- Todo en `Features/Legacy/`
- Mantenidos solo para referencia histórica

---

## 🎨 Sistema de Diseño

### **AppTheme centralizado**
```swift
AppTheme.Colors.primaryText     // ✅ Texto principal
AppTheme.Colors.secondaryText   // ✅ Texto secundario  
AppTheme.Colors.cardBackground  // ✅ Fondo de tarjetas
AppTheme.Spacing.md            // ✅ Espaciado medio
AppTheme.CornerRadius.medium   // ✅ Radio de esquinas
```

### **Componentes Reutilizables**
- `CategoryCard` - Selección de categorías
- `EventRowBackend` - Fila de evento
- `StoreGridCard` - Tarjeta de tienda
- `ProductGridCard` - Tarjeta de producto

---

## 🔍 Testing y Debugging

### **Para probar Backend Integration**
1. Usar vistas en `Features/Backend/`
2. Login: `admin@proyectox.com` / `password123`
3. Verificar datos reales de Madrid

### **Para comparar con versión anterior**
1. Consultar `Features/Legacy/` (solo para referencia)
2. **NO ejecutar** - solo leer código

---

## 📈 Próximos Pasos

### **Inmediato (Esta semana)**
- ✅ Verificar que toda la navegación funcione
- ✅ Probar todos los flujos de Backend
- ✅ Validar autenticación JWT

### **Corto plazo (2-4 semanas)**
- 🔄 Optimizar rendimiento de carga de datos
- 🔄 Agregar animaciones y transiciones
- 🔄 Implementar caché local

### **Largo plazo (1-3 meses)**
- 🔄 Añadir más funcionalidades del backend
- 🔄 Implementar notificaciones push
- 🔄 Preparar para App Store

---

## ⚠️ Reglas Importantes

### **DO's ✅**
- Usar solo vistas en `Features/Backend/`
- Seguir el sistema `AppTheme` para colores
- Mantener componentes en `BackendComponents.swift`
- Documentar cambios importantes

### **DON'Ts ❌**
- **NO usar** vistas en `Features/Legacy/`
- **NO modificar** archivos Legacy
- **NO crear** colores personalizados fuera de AppTheme
- **NO duplicar** componentes entre carpetas

---

## 👥 Para el Equipo

### **Si eres nuevo en el proyecto**
1. Lee `INTEGRACION-iOS-BACKEND.md` primero
2. Revisa la estructura en `Features/Backend/`
3. Ignore completamente `Features/Legacy/`

### **Si necesitas algo de Legacy**
1. **COPIA** el código (no lo muevas)
2. **ADAPTA** al sistema Backend
3. **COLOCA** en la carpeta Backend apropiada

---

*Documentación creada: 10 Agosto 2025*
*Arquitectura Profesional v2.0*
*Proyecto X SaaS - Estructura Reorganizada*