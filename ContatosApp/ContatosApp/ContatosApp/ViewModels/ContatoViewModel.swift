import Foundation
import Combine

class ContatoViewModel: ObservableObject {
    // Published properties para atualizar a UI automaticamente
    @Published var listaContatos: [Contato] = []
    @Published var estaCarregando = false
    @Published var mensagemErro: String?
    @Published var mostrarAlerta = false
    
    // URL base da API local
    private let baseURL = "http://localhost:3001/api/contatos"
    
    // MARK: - CRUD Operations
    
    // CREATE - Cadastrar novo contato
    func cadastrarContato(contato: Contato, onSuccess: @escaping () -> Void) {
        guard let url = URL(string: baseURL) else {
            exibirErro("URL inválida")
            return
        }
        
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "POST"
        requisicao.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Converter contato para JSON
        guard let dadosJSON = try? JSONEncoder().encode(contato) else {
            exibirErro("Erro ao converter dados")
            return
        }
        
        requisicao.httpBody = dadosJSON
        
        estaCarregando = true
        
        URLSession.shared.dataTask(with: requisicao) { data, resposta, erro in
            DispatchQueue.main.async {
                self.estaCarregando = false
                
                if let erro = erro {
                    self.exibirErro("Erro de conexão: \(erro.localizedDescription)")
                    return
                }
                
                guard let httpResposta = resposta as? HTTPURLResponse else {
                    self.exibirErro("Resposta inválida do servidor")
                    return
                }
                
                if httpResposta.statusCode == 201 {
                    self.buscarContatos()
                    onSuccess()
                } else {
                    self.exibirErro("Erro ao cadastrar contato (Status: \(httpResposta.statusCode))")
                }
            }
        }.resume()
    }
    
    // READ - Buscar todos os contatos
    func buscarContatos() {
        guard let url = URL(string: baseURL) else {
            exibirErro("URL inválida")
            return
        }
        
        estaCarregando = true
        mensagemErro = nil
        
        URLSession.shared.dataTask(with: url) { data, resposta, erro in
            DispatchQueue.main.async {
                self.estaCarregando = false
                
                if let erro = erro {
                    self.exibirErro("Erro ao carregar contatos: \(erro.localizedDescription)")
                    return
                }
                
                guard let data = data else {
                    self.exibirErro("Nenhum dado recebido")
                    return
                }
                
                do {
                    let contatos = try JSONDecoder().decode([Contato].self, from: data)
                    self.listaContatos = contatos
                } catch {
                    self.exibirErro("Erro ao decodificar dados: \(error.localizedDescription)")
                }
            }
        }.resume()
    }
    
    // UPDATE - Atualizar contato existente
    func atualizarContato(contato: Contato, onSuccess: @escaping () -> Void) {
        guard let id = contato.id, let url = URL(string: "\(baseURL)/\(id)") else {
            exibirErro("ID do contato inválido")
            return
        }
        
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "PUT"
        requisicao.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let dadosJSON = try? JSONEncoder().encode(contato) else {
            exibirErro("Erro ao converter dados")
            return
        }
        
        requisicao.httpBody = dadosJSON
        
        estaCarregando = true
        
        URLSession.shared.dataTask(with: requisicao) { data, resposta, erro in
            DispatchQueue.main.async {
                self.estaCarregando = false
                
                if let erro = erro {
                    self.exibirErro("Erro de conexão: \(erro.localizedDescription)")
                    return
                }
                
                guard let httpResposta = resposta as? HTTPURLResponse else {
                    self.exibirErro("Resposta inválida do servidor")
                    return
                }
                
                if httpResposta.statusCode == 200 {
                    self.buscarContatos()
                    onSuccess()
                } else {
                    self.exibirErro("Erro ao atualizar contato (Status: \(httpResposta.statusCode))")
                }
            }
        }.resume()
    }
    
    // DELETE - Remover contato
    func removerContato(emIndices indices: IndexSet) {
        indices.forEach { indice in
            let contato = listaContatos[indice]
            guard let id = contato.id, let url = URL(string: "\(baseURL)/\(id)") else {
                return
            }
            
            var requisicao = URLRequest(url: url)
            requisicao.httpMethod = "DELETE"
            
            URLSession.shared.dataTask(with: requisicao) { _, resposta, erro in
                DispatchQueue.main.async {
                    if let erro = erro {
                        self.exibirErro("Erro ao remover: \(erro.localizedDescription)")
                        return
                    }
                    
                    guard let httpResposta = resposta as? HTTPURLResponse else {
                        return
                    }
                    
                    if httpResposta.statusCode == 204 {
                        self.listaContatos.remove(at: indice)
                    } else {
                        self.exibirErro("Erro ao remover contato")
                    }
                }
            }.resume()
        }
    }
    
    // MARK: - ViaCEP Integration
    
    func buscarEnderecoPorCEP(_ cep: String, completion: @escaping (EnderecoViaCEP?) -> Void) {
        // Limpar o CEP (remover hífen)
        let cepLimpo = cep.removerFormatacao()
        
        // Validar tamanho
        guard cepLimpo.count == 8 else {
            exibirErro("CEP inválido. Digite 8 dígitos.")
            completion(nil)
            return
        }
        
        // Montar URL do ViaCEP
        let urlString = "https://viacep.com.br/ws/\(cepLimpo)/json/"
        guard let url = URL(string: urlString) else {
            exibirErro("Erro ao montar URL do CEP")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, resposta, erro in
            DispatchQueue.main.async {
                if let erro = erro {
                    self.exibirErro("Erro ao buscar CEP: \(erro.localizedDescription)")
                    completion(nil)
                    return
                }
                
                guard let data = data else {
                    self.exibirErro("Nenhum dado retornado do ViaCEP")
                    completion(nil)
                    return
                }
                
                do {
                    let endereco = try JSONDecoder().decode(EnderecoViaCEP.self, from: data)
                    
                    // Verificar se houve erro
                    if endereco.erro == true {
                        self.exibirErro("CEP não encontrado")
                        completion(nil)
                    } else {
                        completion(endereco)
                    }
                } catch {
                    self.exibirErro("Erro ao processar dados do CEP")
                    completion(nil)
                }
            }
        }.resume()
    }
    
    // MARK: - Helpers
    
    private func exibirErro(_ mensagem: String) {
        mensagemErro = mensagem
        mostrarAlerta = true
    }
}
