
import SwiftUI

// View principal
struct ContentView: View {
    
    // ViewModel
    @StateObject private var viewModel = ShopViewModel()
    
    // Body
    var body: some View {
        
        // TabView para navegação entre seções
        TabView {
            
            // Aba 1: Eletrônicos
            ProductListView(category: "Eletrônicos", viewModel: viewModel)
                .tabItem {
                    Image(systemName: "iphone")
                    Text("Eletrônicos")
                }
            
            // Aba 2: Roupas
            ProductListView(category: "Roupas", viewModel: viewModel)
                .tabItem {
                    Image(systemName: "tshirt.fill")
                    Text("Roupas")
                }
            
            // Aba 3: Casa
            ProductListView(category: "Casa", viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Casa")
                }
            
            // Aba 4: Livros
            ProductListView(category: "Livros", viewModel: viewModel)
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Livros")
                }
            
            // Aba 5: Carrinho
            CartView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "cart.fill")
                    Text("Carrinho")
                }
        }
        .accentColor(.blue)
    }
}

// Pré-visualização
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
