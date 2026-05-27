import SwiftUI

struct ItemContatoView: View {
    let contato: Contato
    
    var body: some View {
        HStack(spacing: 15) {
            // Avatar com inicial do nome
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color.blue, Color.purple],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 55, height: 55)
                
                Text(obterInicial())
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            // Informações do contato
            VStack(alignment: .leading, spacing: 6) {
                Text(contato.nome)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                HStack(spacing: 5) {
                    Image(systemName: "envelope.fill")
                        .font(.caption)
                    Text(contato.email)
                        .font(.subheadline)
                }
                .foregroundColor(.secondary)
                
                if !contato.telefone.isEmpty {
                    HStack(spacing: 5) {
                        Image(systemName: "phone.fill")
                            .font(.caption)
                        Text(contato.telefone)
                            .font(.subheadline)
                    }
                    .foregroundColor(.secondary)
                }
                
                if !contato.cidade.isEmpty {
                    HStack(spacing: 5) {
                        Image(systemName: "location.fill")
                            .font(.caption)
                        Text("\(contato.cidade)\(!contato.estado.isEmpty ? "/\(contato.estado)" : "")")
                            .font(.caption)
                    }
                    .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // Ícone indicador
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
    
    private func obterInicial() -> String {
        let primeiroNome = contato.nome.split(separator: " ").first ?? ""
        return String(primeiroNome.prefix(1)).uppercased()
    }
}

#Preview {
    List {
        ItemContatoView(contato: Contato(
            id: "1",
            nome: "João Silva",
            email: "joao@email.com",
            telefone: "(11) 98765-4321",
            cidade: "São Paulo",
            estado: "SP"
        ))
    }
}
