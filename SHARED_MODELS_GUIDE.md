# Guía: Compartir Modelos entre Backend Vapor e iOS

## Problema Actual

Estás duplicando definiciones de modelos entre el backend (Vapor) y la app iOS, lo que causa:

- 🔴 Errores de decodificación cuando los modelos no coinciden
- 🔴 Trabajo duplicado al actualizar modelos
- 🔴 Inconsistencias entre backend y cliente

## Solución: Swift Package de Modelos Compartidos

### Opción 1: Swift Package Local (Recomendado para empezar)

#### 1. Crear el Package de Modelos

```bash
# En tu carpeta del proyecto
mkdir ProyectoXModels
cd ProyectoXModels

# Crear Package.swift
swift package init --type library --name ProyectoXModels
```

#### 2. Estructura del Package

```
ProyectoXModels/
├── Package.swift
└── Sources/
    └── ProyectoXModels/
        ├── DTOs/
        │   ├── StoreDTO.swift
        │   ├── ProductDTO.swift
        │   └── EventDTO.swift
        ├── Enums/
        │   ├── ProductCategory.swift
        │   ├── PriceRange.swift
        │   └── EventCategory.swift
        └── Responses/
            ├── AuthResponse.swift
            └── ErrorResponse.swift
```

#### 3. Package.swift

```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ProyectoXModels",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "ProyectoXModels",
            targets: ["ProyectoXModels"]),
    ],
    targets: [
        .target(
            name: "ProyectoXModels",
            dependencies: []),
    ]
)
```

#### 4. Ejemplo: ProductCategory.swift (en el package)

```swift
import Foundation

public enum ProductCategory: String, Codable, CaseIterable, Sendable {
    case bebidas = "bebidas"
    case alimentos = "alimentos"
    case cocteles = "cocteles"
    case promociones = "promociones"
    case pizza = "pizza"
    case burger = "burger"
    case healthy = "healthy"
    case sandwich = "sandwich"
    case sushi = "sushi"
    case grocery = "grocery"
    
    public var displayName: String {
        switch self {
        case .bebidas: return "Bebidas"
        case .alimentos: return "Alimentos"
        case .cocteles: return "Cocteles"
        case .promociones: return "Promociones"
        case .pizza: return "Pizza"
        case .burger: return "Hamburguesas"
        case .healthy: return "Saludable"
        case .sandwich: return "Sándwiches"
        case .sushi: return "Sushi"
        case .grocery: return "Supermercado"
        }
    }
}
```

#### 5. Ejemplo: StoreDTO.swift

```swift
import Foundation

public struct StoreDTO: Codable, Identifiable, Sendable {
    public let id: String
    public let name: String
    public let description: String
    public let category: ProductCategory
    public let rating: Double
    public let reviewCount: Int
    public let deliveryTime: String
    public let address: String
    public let phone: String
    public let isOpen: Bool
    public let latitude: Double
    public let longitude: Double
    public let priceRange: String  // Backend envía string, no enum
    public let specialties: [String]?
    public let features: [String]?
    public let imageName: String?
    public let backgroundColor: String?
    public let createdAt: String
    public let updatedAt: String?
    
    public init(
        id: String,
        name: String,
        description: String,
        category: ProductCategory,
        rating: Double,
        reviewCount: Int,
        deliveryTime: String,
        address: String,
        phone: String,
        isOpen: Bool,
        latitude: Double,
        longitude: Double,
        priceRange: String,
        specialties: [String]? = nil,
        features: [String]? = nil,
        imageName: String? = nil,
        backgroundColor: String? = nil,
        createdAt: String,
        updatedAt: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.category = category
        self.rating = rating
        self.reviewCount = reviewCount
        self.deliveryTime = deliveryTime
        self.address = address
        self.phone = phone
        self.isOpen = isOpen
        self.latitude = latitude
        self.longitude = longitude
        self.priceRange = priceRange
        self.specialties = specialties
        self.features = features
        self.imageName = imageName
        self.backgroundColor = backgroundColor
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
```

#### 6. Integrar en Backend Vapor

En tu backend Vapor, edita `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
    .package(path: "../ProyectoXModels"), // ← Ruta local al package
],
targets: [
    .target(
        name: "App",
        dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "ProyectoXModels", package: "ProyectoXModels"), // ← Importar
        ]
    ),
]
```

Luego en tus controladores:

```swift
import Vapor
import ProyectoXModels

func getStores(req: Request) async throws -> [StoreDTO] {
    let stores = try await Store.query(on: req.db).all()
    return stores.map { $0.toDTO() }
}
```

#### 7. Integrar en iOS App

En Xcode, añade el package local:

1. File → Add Package Dependencies
2. Click "Add Local..."
3. Selecciona la carpeta `ProyectoXModels`

O manualmente en Xcode project settings → Package Dependencies → Add Local

Luego importa en tus archivos:

```swift
import ProyectoXModels

// Ya no necesitas ProductCategory, StoreDTO, etc. en BackendModels.swift
```

---

## Opción 2: Ajustar Modelos iOS para el Backend Actual

Si prefieres NO crear un package por ahora, necesitas ajustar tus modelos iOS para que coincidan **exactamente** con lo que el backend envía.

### Problema detectado en tu código

El backend envía:

```json
{
  "priceRange": "$$",  // ← String, no enum
  "imageName": "pizza_roma",  // ← A veces presente
  "backgroundColor": "#FF6B6B"  // ← Campo que tu modelo no tiene
}
```

Tu modelo espera:

```swift
let priceRange: PriceRange  // ← Enum, causará error
```

### Solución inmediata
