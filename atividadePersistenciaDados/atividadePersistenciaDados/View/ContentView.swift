import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DespesaViewModel()
    @State private var mostrarFormulario = false
    @State private var mostrarResumoMensal = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header com total geral
                VStack(spacing: 8) {
                    Text("Total de Despesas")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    Text(viewModel.formatarMoeda(viewModel.totalGeral()))
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(Color(.systemGroupedBackground))
                
                // Seletor de mês
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(MesAno.allCases, id: \.self) { mes in
                            MesCardView(
                                mes: mes,
                                total: viewModel.totaisPorMes[mes] ?? 0.0,
                                isSelected: viewModel.mesSelecionado == mes
                            )
                            .onTapGesture {
                                withAnimation {
                                    viewModel.mesSelecionado = mes
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 16)
                
                // Lista de despesas do mês
                List {
                    Section {
                        ForEach(viewModel.despesasDoMesSelecionado(), id: \.id) { despesa in
                            NavigationLink {
                                DespesaFormView(viewModel: viewModel, despesaParaEditar: despesa)
                            } label: {
                                DespesaRowView(despesa: despesa, viewModel: viewModel)
                            }
                        }
                        .onDelete { indexSet in
                            for index in indexSet {
                                let despesa = viewModel.despesasDoMesSelecionado()[index]
                                viewModel.deletarDespesa(despesa)
                            }
                        }
                    } header: {
                        HStack {
                            Text("\(viewModel.mesSelecionado.rawValue)")
                            Spacer()
                            Text(viewModel.formatarMoeda(viewModel.totalDoMesSelecionado()))
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    if viewModel.despesasDoMesSelecionado().isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "tray")
                                .font(.system(size: 48))
                                .foregroundColor(.gray)
                            Text("Nenhuma despesa cadastrada")
                                .foregroundColor(.secondary)
                            Text("Toque no botão + para adicionar")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Despesas Domésticas")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        mostrarResumoMensal = true
                    } label: {
                        Image(systemName: "chart.bar.fill")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        mostrarFormulario = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $mostrarFormulario) {
                DespesaFormView(viewModel: viewModel)
            }
            .sheet(isPresented: $mostrarResumoMensal) {
                ResumoMensalView(viewModel: viewModel)
            }
            .alert("Aviso", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.alertMessage)
            }
        }
    }
}

// MARK: - MesCardView

struct MesCardView: View {
    let mes: MesAno
    let total: Double
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Text(mes.rawValue)
                .font(.subheadline)
                .fontWeight(isSelected ? .bold : .regular)
            
            Text(formatarMoeda(total))
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(width: 90)
        .padding(.vertical, 12)
        .background(isSelected ? Color.blue.opacity(0.2) : Color(.systemGray6))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
    
    private func formatarMoeda(_ valor: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: valor)) ?? "R$ 0,00"
    }
}

// MARK: - DespesaRowView

struct DespesaRowView: View {
    let despesa: DespesaEntity
    let viewModel: DespesaViewModel
    
    var body: some View {
        HStack(spacing: 12) {
            // Ícone da categoria
            if let categoriaStr = despesa.categoria,
               let categoria = CategoriaGasto(rawValue: categoriaStr) {
                Image(systemName: categoria.icone)
                    .font(.title2)
                    .foregroundColor(corDaCategoria(categoria.cor))
                    .frame(width: 40, height: 40)
                    .background(corDaCategoria(categoria.cor).opacity(0.2))
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(despesa.categoria ?? "Sem categoria")
                    .font(.headline)
                
                if let descricao = despesa.descricao, !descricao.isEmpty {
                    Text(descricao)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Text(viewModel.formatarMoeda(despesa.valor))
                .font(.headline)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
    
    private func corDaCategoria(_ cor: String) -> Color {
        switch cor {
        case "yellow": return .yellow
        case "blue": return .blue
        case "cyan": return .cyan
        case "purple": return .purple
        case "orange": return .orange
        case "green": return .green
        case "red": return .red
        case "pink": return .pink
        default: return .gray
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
