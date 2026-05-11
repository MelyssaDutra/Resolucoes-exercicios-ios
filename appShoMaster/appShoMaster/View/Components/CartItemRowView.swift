
import SwiftUI

// Componente para exibir item no carrinho
struct CartItemRowView: View {
    
    // Dados do item
    let cartItem: CartItem
    
    // Callbacks
    let onQuantityChange: (UUID, Int) -> Void
    let onDelete: (UUID) -> Void
    
   
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            // Ícone + nome + preço unitário
            HStack {
                Text(cartItem.product.icon)
                    .font(.system(size: 28))
                
                VStack(alignment: .leading) {
                    Text(cartItem.product.name)
                        .font(.headline)
                    
                    Text("R$ \(String(format: "%.2f", cartItem.product.price))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Subtotal")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("R$ \(String(format: "%.2f", cartItem.subtotal))")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.green)
                }
            }
            
            // Quantidade + botão remover
            HStack {
                HStack(spacing: 8) {
                    Button(action: {
                        onQuantityChange(cartItem.id, cartItem.quantity - 1)
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.blue)
                    }
                    
                    Text("\(cartItem.quantity)")
                        .frame(minWidth: 30)
                        .multilineTextAlignment(.center)
                        .font(.headline)
                    
                    Button(action: {
                        onQuantityChange(cartItem.id, cartItem.quantity + 1)
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(6)
                
                Spacer()
                
                Button(action: { onDelete(cartItem.id) }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
