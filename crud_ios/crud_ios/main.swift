/*
 Sistema de Gerenciamento de Contatos
 Aplicando os conceitos do Curso iOS - Capgemini
*/

/*
 Modo de uso digite os numeros de 1 a 5 para  cadastrar, listar, alterar, remover e finalizar o sistema
*/


import Foundation

//  Protocol Base
protocol Contato {
    var id: Int { get }
    var nome: String { get set }
    var idade: Int { get set }
    var telefone: String { get set }
    var email: String { get set }
}

// Implementação do Contato
struct ContatoPessoa: Contato {
    let id: Int
    var nome: String
    var idade: Int
    var telefone: String
    var email: String
}

// CRUD
struct ContatoCRUD<T: Contato> {
    private var lista: [T] = []
    private var proximoId: Int = 1
    
    // MARK: - CREATE (Cadastro)
    mutating func cadastrar(nome: String, idade: Int, telefone: String, email: String) -> Bool {
        
        // Validação: campos obrigatórios
        guard !nome.trimmingCharacters(in: .whitespaces).isEmpty,
              idade > 0,
              !telefone.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            print(" Todas as informações devem estar preenchidas")
            return false
        }
        
        // Validação: nome único
        if lista.contains(where: { $0.nome.lowercased() == nome.trimmingCharacters(in: .whitespaces).lowercased() }) {
            print(" Já existe um contato com o nome '\(nome)'")
            return false
        }
        
        // Criar novo contato
        let novoContato = ContatoPessoa(
            id: proximoId,
            nome: nome.trimmingCharacters(in: .whitespaces),
            idade: idade,
            telefone: telefone.trimmingCharacters(in: .whitespaces),
            email: email.trimmingCharacters(in: .whitespaces)
        ) as! T
        
        lista.append(novoContato)
        proximoId += 1
        
        print("Contato cadastrado com sucesso!")
        print("   ID: \(novoContato.id) | Nome: \(novoContato.nome)")
        return true
    }
    
    // Listagem
    func listar() -> [T] {
        return lista
    }
    
    func listarCompleta() {
        if lista.isEmpty {
            print("Nenhum contato cadastrado")
            return
        }
        
        print("\n === LISTA COMPLETA DE CONTATOS ===")
        for contato in lista {
            print("ID: \(contato.id)")
            print("Nome: \(contato.nome)")
            print("Idade: \(contato.idade) anos")
            print(" Telefone: \(contato.telefone)")
            print("E-mail: \(contato.email)")
            print("─────────────────────────────")
        }
    }
    
    func listarNomes() {
        if lista.isEmpty {
            print("Nenhum contato cadastrado")
            return
        }
        
        print("\n === CONTATOS CADASTRADOS ===")
        for contato in lista {
            print("\(contato.id) - \(contato.nome)")
        }
    }
    
    // Alteração
    mutating func alterar(id: Int, nome: String, idade: Int, telefone: String, email: String) -> Bool {
        
        // Validar se ID existe
        guard let index = lista.firstIndex(where: { $0.id == id }) else {
            print(" Identificador \(id) não encontrado")
            print("   Por favor, selecione um ID válido da lista acima")
            return false
        }
        
        // Validação: campos obrigatórios
        guard !nome.trimmingCharacters(in: .whitespaces).isEmpty,
              idade > 0,
              !telefone.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            print("Todas as informações devem estar preenchidas")
            return false
        }
        
        // Validação: nome único (exceto o próprio contato)
        let nomeNormalizado = nome.trimmingCharacters(in: .whitespaces).lowercased()
        if lista.enumerated().contains(where: { index != $0.offset && $0.element.nome.lowercased() == nomeNormalizado }) {
            print(" Já existe outro contato com o nome '\(nome)'")
            return false
        }
        
        // Atualizar contato
        let contatoAtualizado = ContatoPessoa(
            id: id,
            nome: nome.trimmingCharacters(in: .whitespaces),
            idade: idade,
            telefone: telefone.trimmingCharacters(in: .whitespaces),
            email: email.trimmingCharacters(in: .whitespaces)
        ) as! T
        
        lista[index] = contatoAtualizado
        
        print("Contato alterado com sucesso!")
        print("   ID: \(id) | Novo nome: \(contatoAtualizado.nome)")
        return true
    }
    
    //  DELETE
    mutating func remover(id: Int) -> Bool {
        
        // Validar se ID existe
        guard let contato = lista.first(where: { $0.id == id }) else {
            print(" Identificador \(id) não encontrado")
            print("   Por favor, selecione um ID válido da lista acima")
            return false
        }
        
        // Remover contato
        lista.removeAll { $0.id == id }
        
        print("Contato removido com sucesso!")
        print("   Nome removido: \(contato.nome)")
        return true
    }
    
    // Função auxiliar
    func obterContatoPorId(_ id: Int) -> T? {
        return lista.first { $0.id == id }
    }
}

// Sistema de Menu Principal
struct SistemaDeContatos {
    private var crud = ContatoCRUD<ContatoPessoa>()
    
    mutating func iniciar() {
        var continuar = true
        
        print(" === SISTEMA DE GERENCIAMENTO DE CONTATOS ===")
        print("   Baseado nos conceitos do Curso iOS - Capgemini\n")
        
        while continuar {
            exibirMenu()
            
            if let opcao = lerOpcao() {
                switch opcao {
                case 1:
                    menuCadastro()
                case 2:
                    menuListagem()
                case 3:
                    menuAlteracao()
                case 4:
                    menuRemocao()
                case 5:
                    continuar = false
                    print(" Obrigado por usar o Sistema de Contatos!")
                    print("   Sistema finalizado.")
                default:
                    print("Opção inválida! Escolha uma opção de 1 a 5")
                }
            } else {
                print("Por favor, digite um número válido")
            }
            
            if continuar {
                print("\nPressione ENTER para continuar...")
                _ = readLine()
            }
        }
    }
    
    //  Menus
    private func exibirMenu() {
        print("Volte para o === MENU PRINCIPAL ===")
        print(" Cadastrar Contato")
        print(" Listar Contatos")
        print(" Alterar Contato")
        print(" Remover Contato")
        print(" Finalizar Sistema")
        print("─────────────────────────")
        print("Escolha uma opção: ", terminator: "")
    }
    
    private mutating func menuCadastro() {
        print("\n➕ === CADASTRO DE CONTATO ===")
        
        print("Digite o nome: ", terminator: "")
        let nome = readLine() ?? ""
        
        print("Digite a idade: ", terminator: "")
        let idade = Int(readLine() ?? "") ?? 0
        
        print("Digite o telefone: ", terminator: "")
        let telefone = readLine() ?? ""
        
        print("Digite o e-mail: ", terminator: "")
        let email = readLine() ?? ""
        
        let _ = crud.cadastrar(nome: nome, idade: idade, telefone: telefone, email: email)
    }
    
    private func menuListagem() {
        print("\n === LISTAGEM DE CONTATOS ===")
        crud.listarCompleta()
    }
    
    private mutating func menuAlteracao() {
        print("\n === ALTERAÇÃO DE CONTATO ===")
        
        // Listar contatos para seleção
        crud.listarNomes()
        
        if crud.listar().isEmpty {
            return
        }
        
        print("\nDigite o ID do contato para alterar: ", terminator: "")
        guard let id = Int(readLine() ?? "") else {
            print(" ID inválido")
            return
        }
        
        // Mostrar dados atuais
        if let contatoAtual = crud.obterContatoPorId(id) {
            print("\n Dados atuais:")
            print("   Nome: \(contatoAtual.nome)")
            print("   Idade: \(contatoAtual.idade)")
            print("   Telefone: \(contatoAtual.telefone)")
            print("   E-mail: \(contatoAtual.email)")
            print("\n Digite os novos dados:")
        }
        
        print("Digite o novo nome: ", terminator: "")
        let nome = readLine() ?? ""
        
        print("Digite a nova idade: ", terminator: "")
        let idade = Int(readLine() ?? "") ?? 0
        
        print("Digite o novo telefone: ", terminator: "")
        let telefone = readLine() ?? ""
        
        print("Digite o novo e-mail: ", terminator: "")
        let email = readLine() ?? ""
        
        let _ = crud.alterar(id: id, nome: nome, idade: idade, telefone: telefone, email: email)
    }
    
    private mutating func menuRemocao() {
        print("\n🗑️ === REMOÇÃO DE CONTATO ===")
        
        // Listar contatos para seleção
        crud.listarNomes()
        
        if crud.listar().isEmpty {
            return
        }
        
        print("\nDigite o ID do contato para remover: ", terminator: "")
        guard let id = Int(readLine() ?? "") else {
            print("ID inválido")
            return
        }
        
        let _ = crud.remover(id: id)
    }
    
    //  Utilitários
    private func lerOpcao() -> Int? {
        return Int(readLine() ?? "")
    }
}

// Execução do Sistema
print(" Iniciando Sistema de Contatos...")


var sistema = SistemaDeContatos()
sistema.iniciar()
