import SwiftUI

struct ResumoMensalView: View {
    @ObservedObject var viewModel: DespesaViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                // Resumo geral
                Section {
                    HStack {
                        Text("Total Geral")
                            .font(.headline)
                        Spacer()
                        Text(viewModel.formatarMoeda(viewModel.totalGeral()))
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                
                // Resumo por mês
                ForEach(MesAno.allCases, id: \.self) { mes in
                    Section(mes.rawValue) {
                        // Total do mês
                        HStack {
                            Text("Total do Mês")
                                .fontWeight(.semibold)
                            Spacer()
                            Text(viewModel.formatarMoeda(viewModel.totaisPorMes[mes] ?? 0.0))
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        
                        // Despesas por categoria
                        let categorias = viewModel.despesasPorCategoria(mes: mes)
                        if !categorias.isEmpty {
                            ForEach(Array(categorias.sorted(by: { $0.value > $1.value })), id: \.key) { categoria, valor in
                                HStack {
                                    Image(systemName: categoria.icone)
                                        .foregroundColor(corDaCategoria(categoria.cor))
                                    Text(categoria.rawValue)
                                    Spacer()
                                    Text(viewModel.formatarMoeda(valor))
                                        .foregroundColor(.secondary)
                                }
                            }
                        } else {
                            Text("Nenhuma despesa cadastrada")
                                .foregroundColor(.secondary)
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Resumo Mensal")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Fechar") {
                        dismiss()
                    }
                }
            }
        }
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
    ResumoMensalView(viewModel: DespesaViewModel(persistenceController: .preview))
}
