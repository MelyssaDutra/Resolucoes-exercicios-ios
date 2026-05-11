
import Foundation

struct Product: Identifiable, Equatable {
    var id: UUID = UUID()
    var name: String
    var price: Double
    var description: String
    var category: String
    var icon: String
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        lhs.id == rhs.id
    }
}
