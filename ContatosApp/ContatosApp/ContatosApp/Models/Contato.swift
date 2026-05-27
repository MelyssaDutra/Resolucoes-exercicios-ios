import Foundation

// Modelo de Contato
struct Contato: Identifiable, Codable {
    var id: String?
    var nome: String
    var email: String
    var telefone: String
    var nascimento: String
    var cep: String
    var bairro: String
    var logradouro: String
    var numero: String
    var estado: String
    var cidade: String
    
    // Inicializador vazio para facilitar criação de novos contatos
    init(
        id: String? = nil,
        nome: String = "",
        email: String = "",
        telefone: String = "",
        nascimento: String = "",
        cep: String = "",
        bairro: String = "",
        logradouro: String = "",
        numero: String = "",
        estado: String = "",
        cidade: String = ""
    ) {
        self.id = id
        self.nome = nome
        self.email = email
        self.telefone = telefone
        self.nascimento = nascimento
        self.cep = cep
        self.bairro = bairro
        self.logradouro = logradouro
        self.numero = numero
        self.estado = estado
        self.cidade = cidade
    }
}

// Resposta da API ViaCEP
struct EnderecoViaCEP: Decodable {
    let cep: String
    let logradouro: String
    let bairro: String
    let localidade: String  // Cidade
    let uf: String         // Estado
    let complemento: String?
    
    // Verificar se houve erro na busca
    let erro: Bool?
}
