import Foundation
import CoreData
import SwiftUI

class DespesaViewModel: ObservableObject {
    @Published var despesas: [DespesaEntity] = []
    @Published var despesasPorMes: [MesAno: [DespesaEntity]] = [:]
    @Published var totaisPorMes: [MesAno: Double] = [:]
    @Published var mesSelecionado: MesAno = .janeiro
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    private let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController = .shared) {
        self.persistenceController = persistenceController
        carregarDespesas()
    }
    
    // MARK: - Carregar Dados
    
    func carregarDespesas() {
        despesas = persistenceController.buscarDespesas()
        agruparDespesasPorMes()
        calcularTotais()
    }
    
    func carregarDespesasDoMes(_ mes: MesAno) {
        mesSelecionado = mes
        carregarDespesas()
    }
    
    private func agruparDespesasPorMes() {
        despesasPorMes = Dictionary(grouping: despesas) { despesa in
            MesAno(rawValue: despesa.mes ?? "") ?? .janeiro
        }
    }
    
    private func calcularTotais() {
        totaisPorMes = [:]
        for mes in MesAno.allCases {
            totaisPorMes[mes] = persistenceController.calcularTotalPorMes(mes)
        }
    }
    
    // MARK: - CRUD Operations
    
    func adicionarDespesa(categoria: CategoriaGasto, valor: Double, mes: MesAno, descricao: String) {
        do {
            try persistenceController.adicionarDespesa(
                categoria: categoria,
                valor: valor,
                mes: mes,
                descricao: descricao
            )
            carregarDespesas()
            showAlert = true
            alertMessage = "Despesa adicionada com sucesso!"
        } catch {
            showAlert = true
            alertMessage = "Erro ao adicionar despesa: \(error.localizedDescription)"
        }
    }
    
    func atualizarDespesa(_ despesa: DespesaEntity, categoria: CategoriaGasto, valor: Double, mes: MesAno, descricao: String) {
        do {
            try persistenceController.atualizarDespesa(
                despesa,
                categoria: categoria,
                valor: valor,
                mes: mes,
                descricao: descricao
            )
            carregarDespesas()
            showAlert = true
            alertMessage = "Despesa atualizada com sucesso!"
        } catch {
            showAlert = true
            alertMessage = "Erro ao atualizar despesa: \(error.localizedDescription)"
        }
    }
    
    func deletarDespesa(_ despesa: DespesaEntity) {
        do {
            try persistenceController.deletarDespesa(despesa)
            carregarDespesas()
        } catch {
            showAlert = true
            alertMessage = "Erro ao deletar despesa: \(error.localizedDescription)"
        }
    }
    
    // MARK: - Utilitários
    
    func despesasDoMesSelecionado() -> [DespesaEntity] {
        return despesasPorMes[mesSelecionado] ?? []
    }
    
    func totalDoMesSelecionado() -> Double {
        return totaisPorMes[mesSelecionado] ?? 0.0
    }
    
    func totalGeral() -> Double {
        return totaisPorMes.values.reduce(0, +)
    }
    
    func formatarMoeda(_ valor: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: valor)) ?? "R$ 0,00"
    }
    
    func despesasPorCategoria(mes: MesAno) -> [CategoriaGasto: Double] {
        let despesasDoMes = despesasPorMes[mes] ?? []
        var resultado: [CategoriaGasto: Double] = [:]
        
        for despesa in despesasDoMes {
            if let categoriaStr = despesa.categoria,
               let categoria = CategoriaGasto(rawValue: categoriaStr) {
                resultado[categoria, default: 0.0] += despesa.valor
            }
        }
        
        return resultado
    }
}
