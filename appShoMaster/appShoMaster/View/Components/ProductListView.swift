
import SwiftUI

// View para listar produtos de uma categoria
struct ProductListView: View {
    
    // Dados da categoria
    let category: String
    
    // ViewModel
    @ObservedObject var viewModel: ShopViewModel
    
    // Body
    var body: some View {
        
        // NavigationStack
        NavigationStack {
            
            // Lista de produtos
            List {
                
                // Laço de repetição
                ForEach(viewModel.getProductsByCategory(category)) { product in
                    
                    ProductRowView(
                        product: product,
                        onAddToCart: { selectedProduct in
                            viewModel.addToCart(product: selectedProduct)
                        }
                    )
                    .listRowInsets(EdgeInsets())
                    .listRowSeparator(.hidden)
                }
            }
            .listStyle(.plain)
            .navigationTitle(category)
        }
    }
}
