import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    colors: [
                        Color(red: 0.95, green: 1.0, blue: 0.96),
                        Color(red: 1.0, green: 0.94, blue: 0.97)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 14) {
                    Text("Quiz")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.black)

                    Text("Aprenda jogando")
                        .font(.subheadline)
                        .foregroundColor(.black.opacity(0.7))

                    NavigationLink {
                        ExercicioJogoPerguntas()
                    } label: {
                        itemMenu(titulo: "Abrir Jogo de Perguntas", cor: Color(red: 0.10, green: 0.57, blue: 0.34))
                    }

                    NavigationLink {
                        EstruturaReutilizavelQuiz()
                    } label: {
                        itemMenu(titulo: "Temas", cor: Color(red: 0.93, green: 0.37, blue: 0.58))
                    }

                    NavigationLink {
                        EstruturaReutilizavelQuiz2()
                    } label: {
                        itemMenu(titulo: "Configuracao",  cor: Color(red: 0.93, green: 0.37, blue: 0.58))
                    }

                    NavigationLink {
                        VisibilidadeQuiz()
                    } label: {
                        itemMenu(titulo: "Visibilidade Quiz", cor: Color(red: 0.10, green: 0.57, blue: 0.34))
                    }

                    Spacer()
                }
                .padding()
            }
        }
    }

    private func itemMenu(titulo: String, cor: Color) -> some View {
        Text(titulo)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(cor)
            .cornerRadius(12)
    }
}

#Preview {
    ContentView()
}

