import SwiftUI


struct ComponenteConfiguracaoQuiz: View {
    let titulo: String
    @Binding var estaLigado: Bool

    var body: some View {
        HStack {
            Text(titulo)
                .font(.headline)
                .foregroundColor(.black)

            Spacer()

            Toggle("", isOn: $estaLigado)
                .labelsHidden()
                .tint(Color(red: 0.10, green: 0.57, blue: 0.34))
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color(red: 0.93, green: 0.37, blue: 0.58), lineWidth: 1)
        )
    }
}

struct ItemConfigQuiz: Identifiable {
    let id = UUID()
    let nome: String
    var status: Bool
}

struct EstruturaReutilizavelQuiz2: View {
    @State private var configuracoes: [ItemConfigQuiz] = [
        ItemConfigQuiz(nome: "Modo Desafio", status: false),
        ItemConfigQuiz(nome: "Embaralhar Perguntas", status: true),
        ItemConfigQuiz(nome: "Mostrar Dica", status: false)
    ]

    var body: some View {
        VStack(spacing: 12) {
            Text("Configuracoes do Quiz")
                .font(.title3)
                .bold()
                .foregroundColor(.black)

            ForEach($configuracoes) { $item in
                ComponenteConfiguracaoQuiz(
                    titulo: item.nome,
                    estaLigado: $item.status
                )
            }

            Spacer()
        }
        .padding()
        .background(Color(red: 1.0, green: 0.97, blue: 0.98).ignoresSafeArea())
    }
}

#Preview {
    EstruturaReutilizavelQuiz2()
}
