import SwiftUI


struct CardTemaQuiz: View {
    let titulo: String
    let descricao: String
    let corBorda: Color

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(red: 0.10, green: 0.57, blue: 0.34).opacity(0.2))
                    .frame(width: 42, height: 42)

                Text(String(titulo.prefix(1)))
                    .font(.headline)
                    .foregroundColor(.black)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(titulo)
                    .font(.headline)
                    .foregroundColor(.black)

                Text(descricao)
                    .font(.caption)
                    .foregroundColor(.black.opacity(0.7))
            }

            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(corBorda, lineWidth: 1)
        )
    }
}

struct BotaoOpcaoQuiz: View {
    let texto: String
    let acao: () -> Void

    var body: some View {
        Button(action: acao) {
            Text(texto)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(red: 0.93, green: 0.37, blue: 0.58), lineWidth: 1)
                )
        }
    }
}

struct EstruturaReutilizavelQuiz: View {
    var body: some View {
        VStack(spacing: 12) {
            CardTemaQuiz(
                titulo: "Historia",
                descricao: "Perguntas sobre fatos historicos",
                corBorda: Color(red: 0.10, green: 0.57, blue: 0.34)
            )

            CardTemaQuiz(
                titulo: "Matematica",
                descricao: "Perguntas com calculos e logica",
                corBorda: Color(red: 0.93, green: 0.37, blue: 0.58)
            )
        }
        .padding()
        .background(Color(red: 0.98, green: 1.0, blue: 0.98))
    }
}

#Preview {
    EstruturaReutilizavelQuiz()
}
