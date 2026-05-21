import Foundation

enum MesAno: String, CaseIterable, Codable {
    case janeiro = "Janeiro"
    case fevereiro = "Fevereiro"
    case marco = "Março"
    case abril = "Abril"
    case maio = "Maio"
    
    var numero: Int {
        switch self {
        case .janeiro: return 1
        case .fevereiro: return 2
        case .marco: return 3
        case .abril: return 4
        case .maio: return 5
        }
    }
}
