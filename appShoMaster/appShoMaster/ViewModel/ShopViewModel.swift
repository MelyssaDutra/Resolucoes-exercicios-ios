// Importar Foundation
import Foundation

// ViewModel
class ShopViewModel: ObservableObject {
    
    // Produtos publicados
    @Published var products: [Product] = []
    
    // Carrinho publicado
    @Published var cartItems: [CartItem] = []
    
    // Categorias
    @Published var categories: [String] = ["Eletrônicos", "Roupas", "Casa", "Livros"]
    
    // Construtor
    init() {
        loadProducts()
    }
    
    // Função para carregar produtos
    private func loadProducts() {
        products = [
            // Eletrônicos
            Product(name: "iPhone 15", price: 5499.00, description: "Smartphone de última geração", category: "Eletrônicos", icon: "📱"),
            Product(name: "MacBook Air", price: 9999.00, description: "Laptop ultraportátil", category: "Eletrônicos", icon: "💻"),
            Product(name: "AirPods Pro", price: 2249.00, description: "Fones de ouvido com cancelamento ativo", category: "Eletrônicos", icon: "🎧"),
            Product(name: "iPad Air", price: 6999.00, description: "Tablet versátil e poderoso", category: "Eletrônicos", icon: "📱"),
            
            // Roupas
            Product(name: "Camiseta básica", price: 79.90, description: "Camiseta de algodão 100%", category: "Roupas", icon: "👕"),
            Product(name: "Calça jeans", price: 189.90, description: "Calça jeans premium", category: "Roupas", icon: "👖"),
            Product(name: "Jaqueta", price: 399.90, description: "Jaqueta de couro genuíno", category: "Roupas", icon: "🧥"),
            Product(name: "Tênis esportivo", price: 349.90, description: "Tênis para corrida e academia", category: "Roupas", icon: "👟"),
            
            // Casa
            Product(name: "Luminária LED", price: 199.90, description: "Luminária inteligente ajustável", category: "Casa", icon: "💡"),
            Product(name: "Travesseiro memory foam", price: 299.90, description: "Travesseiro ergonômico premium", category: "Casa", icon: "🛏️"),
            Product(name: "Panela antiaderente", price: 159.90, description: "Jogo de 3 panelas", category: "Casa", icon: "🍳"),
            Product(name: "Cortina blackout", price: 249.90, description: "Cortina 100% bloqueio de luz", category: "Casa", icon: "🪟"),
            
            // Livros
            Product(name: "Clean Code", price: 145.90, description: "Guia de código limpo", category: "Livros", icon: "📚"),
            Product(name: "O Trabalho Remoto", price: 89.90, description: "Produtividade sem sair de casa", category: "Livros", icon: "📕"),
            Product(name: "Design Patterns", price: 125.90, description: "Padrões reutilizáveis", category: "Livros", icon: "📗"),
            Product(name: "Swift Programming", price: 189.90, description: "Guia completo da linguagem Swift", category: "Livros", icon: "📘")
        ]
    }
    
    // Função para obter produtos por categoria
    func getProductsByCategory(_ category: String) -> [Product] {
        products.filter { $0.category == category }
    }
    
    // Função para adicionar produto ao carrinho
    func addToCart(product: Product, quantity: Int = 1) {
        // Verificar se produto já existe no carrinho
        if let index = cartItems.firstIndex(where: { $0.product.id == product.id }) {
            // Se existe, aumenta a quantidade
            cartItems[index].quantity += quantity
        } else {
            // Se não existe, cria novo item
            let newItem = CartItem(product: product, quantity: quantity)
            cartItems.append(newItem)
        }
    }
    
    // Função para remover item do carrinho
    func removeFromCart(at offsets: IndexSet) {
        cartItems.remove(atOffsets: offsets)
    }
    
    // Função para remover item específico do carrinho por ID
    func removeFromCart(itemId: UUID) {
        if let index = cartItems.firstIndex(where: { $0.id == itemId }) {
            cartItems.remove(at: index)
        }
    }
    
    // Função para atualizar quantidade de item no carrinho
    func updateQuantity(itemId: UUID, quantity: Int) {
        if let index = cartItems.firstIndex(where: { $0.id == itemId }) {
            if quantity <= 0 {
                cartItems.remove(at: index)
            } else {
                cartItems[index].quantity = quantity
            }
        }
    }
    
    // Propriedade computada para calcular total do carrinho
    var cartTotal: Double {
        cartItems.reduce(0) { $0 + $1.subtotal }
    }
    
    // Propriedade computada para contar itens no carrinho
    var cartItemCount: Int {
        cartItems.count
    }
}
