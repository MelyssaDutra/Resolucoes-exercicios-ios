import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContatoViewModel()
    @State private var mostrarFormulario = false
    @State private var contatoParaEditar: Contato?
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.estaCarregando && viewModel.listaContatos.isEmpty {
                    // Indicador de carregamento inicial
                    VStack(spacing: 20) {
                        ProgressView()
                            .scaleEffect(1.5)
                        Text("Carregando contatos...")
                            .foregroundColor(.secondary)
                    }
                } else if viewModel.listaContatos.isEmpty {
                    // Estado vazio
                    VStack(spacing: 20) {
                        Image(systemName: "person.crop.circle.badge.questionmark")
                            .font(.system(size: 70))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("Nenhum contato encontrado")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        
                        Text("Toque no botão + para adicionar um novo contato")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding()
                } else {
                    // Lista de contatos
                    List {
                        ForEach(viewModel.listaContatos) { contato in
                            Button {
                                contatoParaEditar = contato
                                mostrarFormulario = true
                            } label: {
                                ItemContatoView(contato: contato)
                            }
                            .buttonStyle(.plain)
                        }
                        .onDelete(perform: viewModel.removerContato)
                    }
                    .listStyle(.insetGrouped)
                    .refreshable {
                        viewModel.buscarContatos()
                    }
                }
            }
            .navigationTitle("Meus Contatos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        contatoParaEditar = nil
                        mostrarFormulario = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        viewModel.buscarContatos()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .foregroundColor(.blue)
                    }
                }
            }
            .sheet(isPresented: $mostrarFormulario) {
                FormularioContatoView(
                    viewModel: viewModel,
                    contatoParaEditar: contatoParaEditar
                )
            }
            .alert("Atenção", isPresented: $viewModel.mostrarAlerta) {
                Button("OK", role: .cancel) { }
            } message: {
                if let mensagem = viewModel.mensagemErro {
                    Text(mensagem)
                }
            }
            .onAppear {
                if viewModel.listaContatos.isEmpty {
                    viewModel.buscarContatos()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
