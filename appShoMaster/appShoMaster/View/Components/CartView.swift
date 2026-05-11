
import SwiftUI

// View do carrinho
struct CartView: View {
    
    // ViewModel
    @ObservedObject var viewModel: ShopViewModel
 
    var body: some View {
        
        NavigationStack {
            
            // Verificar se carrinho está vazio
            if viewModel.cartItems.isEmpty {
                
                // Mensagem de carrinho vazio
                VStack(spacing: 20) {
                    Image(systemName: "cart")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    
                    Text("Carrinho Vazio")
                        .font(.title2)
                        .bold()
                    
                    Text("Adicione produtos para começar suas compras!")
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemBackground))
                .navigationTitle("Carrinho")
                
            } else {
                
                // Lista com itens do carrinho
                VStack {
                    
                    // Lista de itens
                    List {
                        ForEach(viewModel.cartItems) { item in
                            CartItemRowView(
                                cartItem: item,
                                onQuantityChange: { itemId, newQuantity in
                                    viewModel.updateQuantity(itemId: itemId, quantity: newQuantity)
                                },
                                onDelete: { itemId in
                                    viewModel.removeFromCart(itemId: itemId)
                                }
                            )
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                    
                    // Total e botão finalizar compra
                    VStack(spacing: 12) {
                        
                        Divider()
                        
                        HStack {
                            Text("Total:")
                                .font(.headline)
                            
                            Spacer()
                            
                            Text("R$ \(String(format: "%.2f", viewModel.cartTotal))")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.green)
                        }
                        .padding(.horizontal)
                        
                        // Botão finalizar compra
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Finalizar Compra")
                                    .font(.headline)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                        }
                        .padding()
                    }
                    .background(Color(.systemBackground))
                }
                .navigationTitle("Carrinho (\(viewModel.cartItemCount))")
            }
        }
    }
}
