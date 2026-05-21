import Foundation

enum CategoriaGasto: String, CaseIterable, Codable {
    case energia = "Energia"
    case internet = "Internet"
    case agua = "Água"
    case assinaturas = "Assinaturas"
    case aluguel = "Aluguel"
    case mercado = "Mercado"
    case cursos = "Cursos"
    case lazer = "Lazer"
    
    var icone: String {
        switch self {
        case .energia:
            return "bolt.fill"
        case .internet:
            return "wifi"
        case .agua:
            return "drop.fill"
        case .assinaturas:
            return "play.tv.fill"
        case .aluguel:
            return "house.fill"
        case .mercado:
            return "cart.fill"
        case .cursos:
            return "book.fill"
        case .lazer:
            return "gamecontroller.fill"
        }
    }
    
    var cor: String {
        switch self {
        case .energia:
            return "yellow"
        case .internet:
            return "blue"
        case .agua:
            return "cyan"
        case .assinaturas:
            return "purple"
        case .aluguel:
            return "orange"
        case .mercado:
            return "green"
        case .cursos:
            return "red"
        case .lazer:
            return "pink"
        }
    }
}
