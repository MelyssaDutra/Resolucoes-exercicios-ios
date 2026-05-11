
import Foundation

// Modelo de Item do Carrinho
struct CartItem: Identifiable, Equatable {
    var id: UUID = UUID()
    var product: Product
    var quantity: Int
    
    // Calcular preço subtotal do item
    var subtotal: Double {
        product.price * Double(quantity)
    }
    
    static func == (lhs: CartItem, rhs: CartItem) -> Bool {
        lhs.id == rhs.id
    }
}
