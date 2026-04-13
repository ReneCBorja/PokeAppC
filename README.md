#  PokeAppC

Una aplicación iOS tipo Pokédex desarrollada con **SwiftUI + UIKit**, utilizando arquitectura **MVVM + Clean Architecture**, que consume datos de Pokémon desde una API REST y los presenta en una interfaz moderna, fluida y escalable.

---

#  Preview

> Agrega aquí capturas o GIFs de la app

| Lista | Detalle |
|------|--------|
|  Pokédex |  Pokémon Detail |

---

#  Características

-  Búsqueda de Pokémon en tiempo real
-  Vista de detalle completa del Pokémon
-  Interfaz híbrida (UIKit + SwiftUI)
-  Carga asíncrona de imágenes
-  Arquitectura MVVM + Clean Architecture
-  Separación por capas (Data / Domain / Presentation)
-  Componentes UI personalizados
-  Estadísticas con barras dinámicas animadas
-  Chips dinámicos por tipo de Pokémon
-  Colores personalizados según tipo

---

#  Arquitectura del proyecto

El proyecto sigue principios de **Clean Architecture**:


Presentation
├── Views
├── ViewModels

Domain
├── Entities
├── Repositories (protocols)

Data
├── Network
├── DTOs
├── Repositories implementations


✔ Separación clara de responsabilidades  
✔ Código escalable y mantenible  
✔ Independencia de la capa de datos  

---

#  Patrones utilizados

- MVVM (Model - View - ViewModel)
- Repository Pattern
- Dependency Injection
- Clean Architecture
- UIKit + SwiftUI Interoperability

---

#  Tecnologías usadas

- Swift 5
- UIKit
- SwiftUI
- Combine
- URLSession
- Xcode
- AutoLayout

---

# Networking

La app consume datos desde una API REST de Pokémon usando:

- APIClient
- PokemonRepository
- DTOs para parsing de respuestas
- Mapeo a entidades de dominio

✔ Separación entre modelos de red y modelos de dominio  
✔ Código desacoplado y testeable  

---

#  UI / UX

- Diseño estilo Pokédex moderna
- Cards limpias con sombras suaves
- Chips de tipos con colores dinámicos
- Barras de estadísticas animadas
- Tipografía personalizada
- Experiencia fluida tipo app App Store

---

#  Estructura del proyecto


PokeAppC
├── Data
│ ├── Network
│ ├── DTOs
│ ├── Repositories
│
├── Domain
│ ├── Entities
│ ├── Repositories (protocols)
│
├── Presentation
│ ├── List
│ ├── Detail
│ ├── ViewModels
│ ├── Components
│
├── Shared
│ ├── Theme
│ ├── Extensions
│
├── Resources
│ ├── Assets.xcassets
│ ├── Fonts


---

#  Cómo ejecutar el proyecto

1. Clona el repositorio

git clone https://github.com/ReneCBorja/PokeAppC.git
Abre el proyecto en Xcode
open PokeAppC.xcodeproj
Ejecuta en simulador o dispositivo físico
 Mejoras futuras
 Cache de imágenes con NSCache
 Skeleton loading (shimmer effect)
 Pagination en lista de Pokémon
 Animaciones avanzadas en transiciones
 Dark Mode completo
 Pull to refresh
 Mejor optimización de networking

 
 Autor

ReneCBorja
iOS Developer 🇸🇻
