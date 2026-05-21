import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Erro ao carregar Core Data: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Preview para SwiftUI
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // Criar dados de exemplo
        for i in 0..<5 {
            let despesa = DespesaEntity(context: viewContext)
            despesa.id = UUID()
            despesa.categoria = CategoriaGasto.allCases[i % CategoriaGasto.allCases.count].rawValue
            despesa.valor = Double.random(in: 50...500)
            despesa.mes = MesAno.allCases[i % MesAno.allCases.count].rawValue
            despesa.descricao = "Despesa de exemplo \(i + 1)"
            despesa.dataCriacao = Date()
        }
        
        do {
            try viewContext.save()
        } catch {
            fatalError("Erro ao criar preview: \(error.localizedDescription)")
        }
        
        return controller
    }()
    
    // MARK: - CRUD Operations
    
    func salvar() throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    func adicionarDespesa(categoria: CategoriaGasto, valor: Double, mes: MesAno, descricao: String) throws {
        let context = container.viewContext
        let despesa = DespesaEntity(context: context)
        despesa.id = UUID()
        despesa.categoria = categoria.rawValue
        despesa.valor = valor
        despesa.mes = mes.rawValue
        despesa.descricao = descricao
        despesa.dataCriacao = Date()
        
        try salvar()
    }
    
    func atualizarDespesa(_ despesa: DespesaEntity, categoria: CategoriaGasto, valor: Double, mes: MesAno, descricao: String) throws {
        despesa.categoria = categoria.rawValue
        despesa.valor = valor
        despesa.mes = mes.rawValue
        despesa.descricao = descricao
        
        try salvar()
    }
    
    func deletarDespesa(_ despesa: DespesaEntity) throws {
        let context = container.viewContext
        context.delete(despesa)
        try salvar()
    }
    
    func buscarDespesas() -> [DespesaEntity] {
        let request: NSFetchRequest<DespesaEntity> = DespesaEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DespesaEntity.dataCriacao, ascending: false)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Erro ao buscar despesas: \(error.localizedDescription)")
            return []
        }
    }
    
    func buscarDespesasPorMes(_ mes: MesAno) -> [DespesaEntity] {
        let request: NSFetchRequest<DespesaEntity> = DespesaEntity.fetchRequest()
        request.predicate = NSPredicate(format: "mes == %@", mes.rawValue)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \DespesaEntity.categoria, ascending: true)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Erro ao buscar despesas do mês: \(error.localizedDescription)")
            return []
        }
    }
    
    func calcularTotalPorMes(_ mes: MesAno) -> Double {
        let despesas = buscarDespesasPorMes(mes)
        return despesas.reduce(0) { $0 + $1.valor }
    }
}
