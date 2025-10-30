# 📁 Legacy Views - Vistas Mock Deshabilitadas

## 🚫 Estado: DESHABILITADO

**Fecha de deshabilitación**: 10 Agosto 2025
**Razón**: Migración completa a Backend Integration

---

## 📋 Vistas en esta carpeta

### **Vistas Mock (No funcionales con backend)**
- `ContentView.swift` - Vista principal original con datos mock
- `HomeView.swift` - Dashboard original con datos estáticos  
- `LoginView.swift` - Login original sin backend
- `AllStoresView.swift` - Lista de tiendas con datos mock
- `EventsView.swift` - Vista de eventos mock
- `ProductsView.swift` - Vista de productos mock
- `AllPromotionsView.swift` - Vista de promociones mock
- `ProfileView.swift` - Perfil de usuario mock

### **Modelos Mock (Obsoletos)**
- `Event.swift` - Modelo de eventos original
- `Product.swift` - Modelo de productos original
- `PromotionStore.swift` - Store de promociones mock

---

## ✅ Vistas Activas (Backend)

Las vistas que **SÍ se están usando** están en:
```
Features/Backend/Views/
├── ContentViewBackend.swift ✅ ACTIVA
├── HomeViewBackend.swift ✅ ACTIVA  
├── LoginViewBackend.swift ✅ ACTIVA
├── AllStoresViewBackend.swift ✅ ACTIVA
└── AllEventsViewBackend.swift ✅ ACTIVA
```

---

## 🔄 Flujo Actual de la App

```
App Start → LoginViewBackend → ContentViewBackend → Tabs Backend
```

**NO se usan las vistas de esta carpeta Legacy**

---

## 🎯 Propósito de mantener Legacy

1. **Referencia histórica** - Para comparar implementaciones
2. **Backup de código** - En caso de necesitar algún componente específico
3. **Documentación** - Para entender la evolución del proyecto
4. **Testing** - Para comparar comportamientos si es necesario

---

## ⚠️ Importante

- **NO modificar** estos archivos
- **NO importar** estos archivos en código activo
- **NO referenciar** estos modelos en vistas Backend
- Si necesitas algo de aquí, **cópialo** a Backend y adáptalo

---

## 🔮 Futuro

Estos archivos pueden ser eliminados cuando:
- ✅ La integración backend esté 100% estable (por al menos 1 mes)
- ✅ No se necesite ningún componente de referencia
- ✅ El equipo confirme que no hay dependencias ocultas

---

*Documentación creada: 10 Agosto 2025*
*Reorganización del proyecto - Estructura Profesional*