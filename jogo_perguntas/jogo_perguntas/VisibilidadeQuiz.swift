import SwiftUI


struct VisibilidadeQuiz: View {
    @State private var mostrarPainel = true

    var body: some View {
        VStack(spacing: 20) {
            Text("Visibilidade - Quiz")
                .font(.title2)
                .bold()
                .foregroundColor(.black)

            RoundedRectangle(cornerRadius: 16)
                .fill(Color(red: 0.10, green: 0.57, blue: 0.34))
                .frame(height: 120)
                .overlay(
                    Text("Painel da pergunta")
                        .foregroundColor(.white)
                        .bold()
                )
                .opacity(mostrarPainel ? 1 : 0)
                .animation(.linear(duration: 0.4), value: mostrarPainel)

            Button("Alternar visibilidade") {
                mostrarPainel.toggle()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color(red: 0.93, green: 0.37, blue: 0.58))
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    VisibilidadeQuiz()
}
