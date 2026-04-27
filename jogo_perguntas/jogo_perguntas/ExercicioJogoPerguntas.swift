import SwiftUI

struct ExercicioJogoPerguntas: View {
    enum Tema: String, CaseIterable, Identifiable {
        case historia = "História"
        case fisica = "Física"
        case geografia = "Geografia"
        case matematica = "Matemática"

        var id: String { rawValue }
    }

    struct Pergunta: Identifiable {
        let id = UUID()
        let tema: Tema
        let enunciado: String
        let opcoes: [String]
        let indiceCorreto: Int
    }

    struct ResultadoRodada: Identifiable {
        let id = UUID()
        let nomeJogador: String
        let tema: Tema
        let acertos: Int
    }

    private let bancoPerguntas: [Pergunta] = [
        Pergunta(
            tema: .historia,
            enunciado: "Em que ano o Brasil declarou sua independência?",
            opcoes: ["1789", "1822", "1889", "1500"],
            indiceCorreto: 1
        ),
        Pergunta(
            tema: .historia,
            enunciado: "Qual civilização construiu Machu Picchu?",
            opcoes: ["Maias", "Astecas", "Incas", "Egípcios"],
            indiceCorreto: 2
        ),
        Pergunta(
            tema: .historia,
            enunciado: "Quem foi o primeiro presidente do Brasil?",
            opcoes: ["Getúlio Vargas", "Marechal Deodoro da Fonseca", "Dom Pedro II", "Juscelino Kubitschek"],
            indiceCorreto: 1
        ),
        Pergunta(
            tema: .historia,
            enunciado: "A Revolução Francesa começou em qual ano?",
            opcoes: ["1776", "1789", "1815", "1750"],
            indiceCorreto: 1
        ),
        Pergunta(
            tema: .historia,
            enunciado: "A Segunda Guerra Mundial terminou em: ",
            opcoes: ["1942", "1945", "1939", "1950"],
            indiceCorreto: 1
        ),
        Pergunta(
            tema: .historia,
            enunciado: "Quem era conhecido como o Libertador da América?",
            opcoes: ["Simón Bolívar", "Che Guevara", "Napoleão", "San Martín"],
            indiceCorreto: 0
        ),
        Pergunta(
            tema: .fisica,
            enunciado: "Qual é a unidade de força no SI?",
            opcoes: ["Joule", "Pascal", "Newton", "Watt"],
            indiceCorreto: 2
        ),
        Pergunta(
            tema: .fisica,
            enunciado: "A velocidade da luz no vácuo é aproximadamente:",
            opcoes: ["300 km/s", "3.000 km/s", "30.000 km/s", "300.000 km/s"],
            indiceCorreto: 3
        ),
        Pergunta(
            tema: .fisica,
            enunciado: "Qual grandeza é medida em volts?",
            opcoes: ["Corrente elétrica", "Resistência", "Tensão elétrica", "Potência"],
            indiceCorreto: 2
        ),
        Pergunta(
            tema: .fisica,
            enunciado: "Quem formulou a lei da gravitação universal?",
            opcoes: ["Einstein", "Galileu", "Newton", "Tesla"],
            indiceCorreto: 2
        ),
        Pergunta(
            tema: .fisica,
            enunciado: "Qual é o estado da matéria com forma e volume definidos?",
            opcoes: ["Líquido", "Gasoso", "Plasma", "Sólido"],
            indiceCorreto: 3
        ),
        Pergunta(
            tema: .fisica,
            enunciado: "A 1ª lei de Newton também é chamada de:",
            opcoes: ["Lei da Inércia", "Lei da Ação e Reação", "Lei da Gravidade", "Lei de Ohm"],
            indiceCorreto: 0
        ),
        Pergunta(
            tema: .geografia,
            enunciado: "Qual é o maior oceano do planeta?",
            opcoes: ["Atlântico", "Índico", "Pacífico", "Ártico"],
            indiceCorreto: 2
        ),
        Pergunta(
            tema: .geografia,
            enunciado: "Qual é a capital do Canadá?",
            opcoes: ["Toronto", "Ottawa", "Vancouver", "Montreal"],
            indiceCorreto: 1
        ),
        Pergunta(
            tema: .geografia,
            enunciado: "O Rio Nilo está localizado em qual continente?",
            opcoes: ["Ásia", "Europa", "África", "América"],
            indiceCorreto: 2
        ),
        Pergunta(
            tema: .geografia,
            enunciado: "Qual país possui o maior território do mundo?",
            opcoes: ["China", "Estados Unidos", "Canadá", "Rússia"],
            indiceCorreto: 3
        ),
        Pergunta(
            tema: .geografia,
            enunciado: "Qual é o bioma predominante no Norte do Brasil?",
            opcoes: ["Mata Atlântica", "Pampa", "Amazônia", "Caatinga"],
            indiceCorreto: 2
        ),
        Pergunta(
            tema: .geografia,
            enunciado: "Qual linha divide a Terra em hemisfério Norte e Sul?",
            opcoes: ["Trópico de Câncer", "Meridiano de Greenwich", "Linha do Equador", "Trópico de Capricórnio"],
            indiceCorreto: 2
        ),
        Pergunta(
            tema: .matematica,
            enunciado: "Quanto é 15% de 200?",
            opcoes: ["20", "25", "30", "35"],
            indiceCorreto: 2
        ),
        Pergunta(
            tema: .matematica,
            enunciado: "Qual é o resultado de 9 x 7?",
            opcoes: ["56", "63", "72", "49"],
            indiceCorreto: 1
        ),
        Pergunta(
            tema: .matematica,
            enunciado: "O valor de pi é aproximadamente:",
            opcoes: ["2,14", "3,14", "4,13", "1,34"],
            indiceCorreto: 1
        ),
        Pergunta(
            tema: .matematica,
            enunciado: "Qual é a raiz quadrada de 144?",
            opcoes: ["10", "11", "12", "13"],
            indiceCorreto: 2
        ),
        Pergunta(
            tema: .matematica,
            enunciado: "Se x + 5 = 12, então x é:",
            opcoes: ["5", "6", "7", "8"],
            indiceCorreto: 2
        ),
        Pergunta(
            tema: .matematica,
            enunciado: "Qual fração representa metade?",
            opcoes: ["1/3", "2/3", "1/4", "1/2"],
            indiceCorreto: 3
        )
    ]

    @State private var nomeJogador: String = ""
    @State private var temaSelecionado: Tema?
    @State private var perguntasRodada: [Pergunta] = []
    @State private var indicePerguntaAtual: Int = 0
    @State private var acertos: Int = 0
    @State private var erros: Int = 0
    @State private var pulosRestantes: Int = 1

    @State private var mensagemFeedback: String = ""
    @State private var mostrarAlertaFeedback: Bool = false
    @State private var rodadaFinalizada: Bool = false
    @State private var mostrarDialogRanking: Bool = false

    @State private var ranking: [ResultadoRodada] = []

    private var perguntaAtual: Pergunta? {
        guard indicePerguntaAtual < perguntasRodada.count else { return nil }
        return perguntasRodada[indicePerguntaAtual]
    }

    var body: some View {
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

            if temaSelecionado == nil {
                telaSelecaoTema
            } else if rodadaFinalizada {
                telaResultado
            } else {
                telaPergunta
            }
        }
        .alert("Resultado da Resposta", isPresented: $mostrarAlertaFeedback) {
            Button("Continuar") {
                avancarFluxo()
            }
        } message: {
            Text(mensagemFeedback)
        }
        .alert("Ranking da Rodada", isPresented: $mostrarDialogRanking) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("\(nomeExibicao) acertou \(acertos) de 5 perguntas no tema \(temaSelecionado?.rawValue ?? "-").")
        }
    }

    private var telaSelecaoTema: some View {
        VStack(spacing: 16) {
            Text("Jogo de Perguntas")
                .font(.title)
                .bold()
                .foregroundColor(.black)

            Text("Digite seu nome e escolha um tema")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.75))

            TextField("Nome do jogador", text: $nomeJogador)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)

            ForEach(Tema.allCases) { tema in
                Button {
                    iniciarJogo(tema: tema)
                } label: {
                    Text(tema.rawValue)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color(red: 0.10, green: 0.57, blue: 0.34))
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }

            if !ranking.isEmpty {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Ultimos resultados")
                        .font(.headline)
                        .foregroundColor(.black)

                    ForEach(ranking.prefix(5)) { item in
                        Text("- \(item.nomeJogador): \(item.acertos) acertos (\(item.tema.rawValue))")
                            .foregroundColor(.black)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.93, green: 0.37, blue: 0.58), lineWidth: 1)
                )
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding(.top)
    }

    private var telaPergunta: some View {
        VStack(spacing: 18) {
            Text("Tema: \(temaSelecionado?.rawValue ?? "-")")
                .font(.headline)
                .foregroundColor(.black)

            Text("Pergunta \(indicePerguntaAtual + 1) de 5")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.7))

            Text(perguntaAtual?.enunciado ?? "")
                .font(.title3)
                .bold()
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.10, green: 0.57, blue: 0.34), lineWidth: 1)
                )
                .padding(.horizontal)

            VStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { indiceOpcao in
                    BotaoOpcaoQuiz(
                        texto: perguntaAtual?.opcoes[indiceOpcao] ?? "",
                        acao: { responder(indiceOpcao) }
                    )
                }
            }
            .padding(.horizontal)

            HStack {
                Text("Acertos: \(acertos)")
                    .foregroundColor(.black)
                Text("Erros: \(erros)")
                    .foregroundColor(.black)
                Text("Pulos: \(pulosRestantes)")
                    .foregroundColor(.black)
            }
            .font(.subheadline)

            Button {
                pularPergunta()
            } label: {
                Text("Pular pergunta")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(pulosRestantes > 0 ? Color(red: 0.93, green: 0.37, blue: 0.58) : Color.black.opacity(0.35))
                    .cornerRadius(10)
            }
            .disabled(pulosRestantes == 0)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
    }

    private var telaResultado: some View {
        VStack(spacing: 18) {
            Text("Fim da Rodada")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.black)

            Text("Jogador: \(nomeExibicao)")
                .foregroundColor(.black)

            Text("Tema: \(temaSelecionado?.rawValue ?? "-")")
                .foregroundColor(.black)

            Text("Acertos: \(acertos)")
                .font(.title2)
                .bold()
                .foregroundColor(Color(red: 0.10, green: 0.57, blue: 0.34))

            Text("Incorretas: \(erros)")
                .font(.title3)
                .foregroundColor(Color(red: 0.93, green: 0.37, blue: 0.58))

            Button {
                voltarParaTemas()
            } label: {
                Text("Jogar novamente")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.black)
                    .cornerRadius(12)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
    }

    private var nomeExibicao: String {
        let nomeTratado = nomeJogador.trimmingCharacters(in: .whitespacesAndNewlines)
        return nomeTratado.isEmpty ? "Jogador(a)" : nomeTratado
    }

    private func iniciarJogo(tema: Tema) {
        temaSelecionado = tema
        perguntasRodada = bancoPerguntas
            .filter { $0.tema == tema }
            .shuffled()

        if perguntasRodada.count > 5 {
            perguntasRodada = Array(perguntasRodada.prefix(5))
        }

        indicePerguntaAtual = 0
        acertos = 0
        erros = 0
        pulosRestantes = 1
        rodadaFinalizada = false
    }

    private func responder(_ indiceOpcao: Int) {
        guard let pergunta = perguntaAtual else { return }

        if indiceOpcao == pergunta.indiceCorreto {
            acertos += 1
            mensagemFeedback = "Resposta correta. Excelente!"
        } else {
            erros += 1
            let correta = pergunta.opcoes[pergunta.indiceCorreto]
            mensagemFeedback = "Resposta incorreta. A correta era: \(correta)."
        }

        mostrarAlertaFeedback = true
    }

    private func pularPergunta() {
        guard pulosRestantes > 0 else { return }
        pulosRestantes -= 1
        erros += 1
        mensagemFeedback = "Pergunta pulada. Ela foi contabilizada como incorreta."
        mostrarAlertaFeedback = true
    }

    private func avancarFluxo() {
        if indicePerguntaAtual >= 4 {
            rodadaFinalizada = true
            ranking.insert(
                ResultadoRodada(nomeJogador: nomeExibicao, tema: temaSelecionado ?? .historia, acertos: acertos),
                at: 0
            )
            mostrarDialogRanking = true
        } else {
            indicePerguntaAtual += 1
        }
    }

    private func voltarParaTemas() {
        temaSelecionado = nil
        perguntasRodada = []
        indicePerguntaAtual = 0
        rodadaFinalizada = false
    }
}

#Preview {
    ExercicioJogoPerguntas()
}
