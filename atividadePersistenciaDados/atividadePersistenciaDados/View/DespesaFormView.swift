import SwiftUI

struct DespesaFormView: View {
    @ObservedObject var viewModel: DespesaViewModel
    @Environment(\.dismiss) var dismiss
    
    let despesaParaEditar: DespesaEntity?
    
    @State private var categoriaSelecionada: CategoriaGasto = .energia
    @State private var valor: String = ""
    @State private var mesSelecionado: MesAno = .janeiro
    @State private var descricao: String = ""
    @State private var mostrarErro = false
    @State private var mensagemErro = ""
    
    init(viewModel: DespesaViewModel, despesaParaEditar: DespesaEntity? = nil) {
        self.viewModel = viewModel
        self.despesaParaEditar = despesaParaEditar
        
        // Inicializar campos se estiver editando
        if let despesa = despesaParaEditar {
            _categoriaSelecionada = State(initialValue: CategoriaGasto(rawValue: despesa.categoria ?? "") ?? .energia)
            _valor = State(initialValue: String(format: "%.2f", despesa.valor))
            _mesSelecionado = State(initialValue: MesAno(rawValue: despesa.mes ?? "") ?? .janeiro)
            _descricao = State(initialValue: despesa.descricao ?? "")
        }
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Categoria") {
                    Picker("Selecione a categoria", selection: $categoriaSelecionada) {
                        ForEach(CategoriaGasto.allCases, id: \.self) { categoria in
                            HStack {
                                Image(systemName: categoria.icone)
                                Text(categoria.rawValue)
                            }
                            .tag(categoria)
                        }
                    }
                    .pickerStyle(.menu)
                }
                
                Section("Valor") {
                    HStack {
                        Text("R$")
                            .foregroundColor(.secondary)
                        TextField("0,00", text: $valor)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section("Mês") {
                    Picker("Selecione o mês", selection: $mesSelecionado) {
                        ForEach(MesAno.allCases, id: \.self) { mes in
                            Text(mes.rawValue).tag(mes)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section("Descrição (Opcional)") {
                    TextEditor(text: $descricao)
                        .frame(minHeight: 100)
                }
                
                Section {
                    Button(action: salvarDespesa) {
                        HStack {
                            Spacer()
                            Text(despesaParaEditar == nil ? "Adicionar Despesa" : "Atualizar Despesa")
                                .fontWeight(.semibold)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle(despesaParaEditar == nil ? "Nova Despesa" : "Editar Despesa")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
            }
            .alert("Erro", isPresented: $mostrarErro) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(mensagemErro)
            }
        }
    }
    
    private func salvarDespesa() {
        // Validar valor
        guard let valorDouble = formatarValor(valor), valorDouble > 0 else {
            mensagemErro = "Por favor, insira um valor válido maior que zero."
            mostrarErro = true
            return
        }
        
        // Salvar ou atualizar
        if let despesa = despesaParaEditar {
            viewModel.atualizarDespesa(
                despesa,
                categoria: categoriaSelecionada,
                valor: valorDouble,
                mes: mesSelecionado,
                descricao: descricao
            )
        } else {
            viewModel.adicionarDespesa(
                categoria: categoriaSelecionada,
                valor: valorDouble,
                mes: mesSelecionado,
                descricao: descricao
            )
        }
        
        dismiss()
    }
    
    private func formatarValor(_ string: String) -> Double? {
        let valorLimpo = string.replacingOccurrences(of: ",", with: ".")
        return Double(valorLimpo)
    }
}

#Preview {
    DespesaFormView(viewModel: DespesaViewModel(persistenceController: .preview))
}
