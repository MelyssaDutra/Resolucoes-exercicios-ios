import SwiftUI

struct FormularioContatoView: View {
    @ObservedObject var viewModel: ContatoViewModel
    @Environment(\.dismiss) var dismiss
    
    let contatoParaEditar: Contato?
    
    // Estados do formulário
    @State private var nome = ""
    @State private var email = ""
    @State private var telefone = ""
    @State private var nascimento = ""
    @State private var cep = ""
    @State private var bairro = ""
    @State private var logradouro = ""
    @State private var numero = ""
    @State private var estado = ""
    @State private var cidade = ""
    
    @State private var estaBuscandoCEP = false
    @State private var mostrarErroValidacao = false
    @State private var mensagemErroValidacao = ""
    
    // Indicador se está em modo de edição
    private var modoEdicao: Bool {
        contatoParaEditar != nil
    }
    
    var body: some View {
        NavigationStack {
            Form {
                // Seção: Dados Pessoais
                Section {
                    campoTexto(
                        icone: "person.fill",
                        placeholder: "Nome completo",
                        texto: $nome
                    )
                    
                    campoTexto(
                        icone: "envelope.fill",
                        placeholder: "E-mail",
                        texto: $email,
                        teclado: .emailAddress,
                        autocapitalizacao: false
                    )
                    
                    campoTextoComMascara(
                        icone: "phone.fill",
                        placeholder: "Telefone",
                        texto: $telefone,
                        teclado: .numberPad,
                        aplicarMascara: { $0.aplicarMascaraTelefone() }
                    )
                    
                    campoTextoComMascara(
                        icone: "calendar",
                        placeholder: "Data de Nascimento (DD/MM/AAAA)",
                        texto: $nascimento,
                        teclado: .numberPad,
                        aplicarMascara: { $0.aplicarMascaraData() }
                    )
                } header: {
                    Label("Dados Pessoais", systemImage: "person.crop.circle")
                        .font(.headline)
                }
                
                // Seção: Endereço
                Section {
                    HStack {
                        campoTextoComMascara(
                            icone: "location.circle.fill",
                            placeholder: "CEP",
                            texto: $cep,
                            teclado: .numberPad,
                            aplicarMascara: { $0.aplicarMascaraCEP() }
                        )
                        
                        if estaBuscandoCEP {
                            ProgressView()
                                .padding(.leading, 8)
                        } else if !cep.isEmpty && cep.removerFormatacao().count == 8 {
                            Button {
                                buscarCEP()
                            } label: {
                                Image(systemName: "magnifyingglass.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    campoTexto(
                        icone: "road.lanes",
                        placeholder: "Logradouro",
                        texto: $logradouro
                    )
                    
                    campoTexto(
                        icone: "building.2",
                        placeholder: "Bairro",
                        texto: $bairro
                    )
                    
                    campoTexto(
                        icone: "number",
                        placeholder: "Número",
                        texto: $numero,
                        teclado: .numberPad
                    )
                    
                    campoTexto(
                        icone: "map.fill",
                        placeholder: "Cidade",
                        texto: $cidade
                    )
                    
                    campoTexto(
                        icone: "mappin.and.ellipse",
                        placeholder: "Estado (UF)",
                        texto: $estado
                    )
                    .textInputAutocapitalization(.characters)
                    .onChange(of: estado) { oldValue, newValue in
                        // Limitar a 2 caracteres e converter para maiúsculas
                        estado = String(newValue.prefix(2)).uppercased()
                    }
                } header: {
                    Label("Endereço", systemImage: "house.fill")
                        .font(.headline)
                } footer: {
                    Text("Digite o CEP e toque na lupa para buscar automaticamente")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Botão de salvar
                Section {
                    Button {
                        salvarContato()
                    } label: {
                        HStack {
                            Spacer()
                            if viewModel.estaCarregando {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text(modoEdicao ? "Atualizar Contato" : "Cadastrar Contato")
                                    .fontWeight(.bold)
                            }
                            Spacer()
                        }
                    }
                    .listRowBackground(Color.blue)
                    .foregroundColor(.white)
                    .disabled(viewModel.estaCarregando)
                }
            }
            .navigationTitle(modoEdicao ? "Editar Contato" : "Novo Contato")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .alert("Erro de Validação", isPresented: $mostrarErroValidacao) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(mensagemErroValidacao)
            }
            .onAppear {
                carregarDadosContato()
            }
        }
    }
    
    // MARK: - Componentes Reutilizáveis
    
    @ViewBuilder
    private func campoTexto(
        icone: String,
        placeholder: String,
        texto: Binding<String>,
        teclado: UIKeyboardType = .default,
        autocapitalizacao: Bool = true
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icone)
                .foregroundColor(.blue)
                .frame(width: 25)
            
            TextField(placeholder, text: texto)
                .keyboardType(teclado)
                .textInputAutocapitalization(autocapitalizacao ? .words : .never)
        }
    }
    
    @ViewBuilder
    private func campoTextoComMascara(
        icone: String,
        placeholder: String,
        texto: Binding<String>,
        teclado: UIKeyboardType = .default,
        aplicarMascara: @escaping (String) -> String
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icone)
                .foregroundColor(.blue)
                .frame(width: 25)
            
            TextField(placeholder, text: texto)
                .keyboardType(teclado)
                .onChange(of: texto.wrappedValue) { oldValue, newValue in
                    texto.wrappedValue = aplicarMascara(newValue)
                }
        }
    }
    
    // MARK: - Funções
    
    private func carregarDadosContato() {
        guard let contato = contatoParaEditar else { return }
        
        nome = contato.nome
        email = contato.email
        telefone = contato.telefone
        nascimento = contato.nascimento
        cep = contato.cep
        bairro = contato.bairro
        logradouro = contato.logradouro
        numero = contato.numero
        estado = contato.estado
        cidade = contato.cidade
    }
    
    private func buscarCEP() {
        guard !cep.isEmpty else { return }
        
        estaBuscandoCEP = true
        
        viewModel.buscarEnderecoPorCEP(cep) { endereco in
            estaBuscandoCEP = false
            
            guard let endereco = endereco else { return }
            
            // Preencher campos automaticamente
            logradouro = endereco.logradouro
            bairro = endereco.bairro
            cidade = endereco.localidade
            estado = endereco.uf
        }
    }
    
    private func validarCampos() -> Bool {
        // Validar campos obrigatórios
        if nome.trimmingCharacters(in: .whitespaces).isEmpty {
            mensagemErroValidacao = "O nome é obrigatório"
            mostrarErroValidacao = true
            return false
        }
        
        if email.trimmingCharacters(in: .whitespaces).isEmpty {
            mensagemErroValidacao = "O e-mail é obrigatório"
            mostrarErroValidacao = true
            return false
        }
        
        // Validar formato de e-mail
        if !email.contains("@") || !email.contains(".") {
            mensagemErroValidacao = "Digite um e-mail válido"
            mostrarErroValidacao = true
            return false
        }
        
        if telefone.trimmingCharacters(in: .whitespaces).isEmpty {
            mensagemErroValidacao = "O telefone é obrigatório"
            mostrarErroValidacao = true
            return false
        }
        
        return true
    }
    
    private func salvarContato() {
        // Validar campos
        guard validarCampos() else { return }
        
        // Criar objeto contato
        let contato = Contato(
            id: contatoParaEditar?.id,
            nome: nome.trimmingCharacters(in: .whitespaces),
            email: email.trimmingCharacters(in: .whitespaces).lowercased(),
            telefone: telefone,
            nascimento: nascimento,
            cep: cep,
            bairro: bairro,
            logradouro: logradouro,
            numero: numero,
            estado: estado,
            cidade: cidade
        )
        
        // Salvar ou atualizar
        if modoEdicao {
            viewModel.atualizarContato(contato: contato) {
                dismiss()
            }
        } else {
            viewModel.cadastrarContato(contato: contato) {
                dismiss()
            }
        }
    }
}

#Preview {
    FormularioContatoView(viewModel: ContatoViewModel(), contatoParaEditar: nil)
}
