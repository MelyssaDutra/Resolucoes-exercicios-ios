
import SwiftUI

// Componente para exibir uma linha de produto
struct ProductRowView: View {
    
    // Dados do produto
    let product: Product
    
    // Callback para quando adicionar ao carrinho
    let onAddToCart: (Product) -> Void
    
    // Body
    var body: some View {
        
        // Card do produto
        VStack(alignment: .leading, spacing: 8) {
            
            // Ícone + nome
            HStack {
                Text(product.icon)
                    .font(.system(size: 32))
                
                VStack(alignment: .leading) {
                    Text(product.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(product.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Preço + botão
            HStack {
                VStack(alignment: .leading) {
                    Text("R$ \(String(format: "%.2f", product.price))")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.green)
                }
                
                Spacer()
                
                Button(action: { onAddToCart(product) }) {
                    HStack {
                        Image(systemName: "cart.badge.plus")
                        Text("Adicionar")
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.blue)
                    .cornerRadius(6)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}
