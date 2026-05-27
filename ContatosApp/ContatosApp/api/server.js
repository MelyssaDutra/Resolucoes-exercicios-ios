// Importar Express
const express = require('express');
const app = express();
const PORT = 3001;

// Middleware para processar JSON
app.use(express.json());

// Array para armazenar contatos em memória
let contatos = [];
let proximoId = 1;

// ============ ROTAS CRUD ============

// CREATE - Cadastrar novo contato
app.post('/api/contatos', (req, res) => {
    const { nome, email, telefone, nascimento, cep, bairro, logradouro, numero, estado, cidade } = req.body;

    // Validação básica
    if (!nome || !email || !telefone) {
        return res.status(400).json({ erro: "Nome, e-mail e telefone são campos obrigatórios." });
    }

    const novoContato = {
        id: proximoId.toString(),
        nome,
        email,
        telefone,
        nascimento: nascimento || "",
        cep: cep || "",
        bairro: bairro || "",
        logradouro: logradouro || "",
        numero: numero || "",
        estado: estado || "",
        cidade: cidade || ""
    };

    contatos.push(novoContato);
    proximoId++;

    return res.status(201).json(novoContato);
});

// READ - Listar todos os contatos
app.get('/api/contatos', (req, res) => {
    return res.status(200).json(contatos);
});

// READ - Buscar contato por ID
app.get('/api/contatos/:id', (req, res) => {
    const { id } = req.params;
    const contato = contatos.find(c => c.id === id);

    if (!contato) {
        return res.status(404).json({ erro: "Contato não encontrado." });
    }

    return res.status(200).json(contato);
});

// UPDATE - Atualizar contato existente
app.put('/api/contatos/:id', (req, res) => {
    const { id } = req.params;
    const { nome, email, telefone, nascimento, cep, bairro, logradouro, numero, estado, cidade } = req.body;

    const indice = contatos.findIndex(c => c.id === id);

    if (indice === -1) {
        return res.status(404).json({ erro: "Contato não encontrado." });
    }

    // Atualizar contato
    contatos[indice] = {
        id,
        nome: nome || contatos[indice].nome,
        email: email || contatos[indice].email,
        telefone: telefone || contatos[indice].telefone,
        nascimento: nascimento || contatos[indice].nascimento,
        cep: cep || contatos[indice].cep,
        bairro: bairro || contatos[indice].bairro,
        logradouro: logradouro || contatos[indice].logradouro,
        numero: numero || contatos[indice].numero,
        estado: estado || contatos[indice].estado,
        cidade: cidade || contatos[indice].cidade
    };

    return res.status(200).json(contatos[indice]);
});

// DELETE - Remover contato
app.delete('/api/contatos/:id', (req, res) => {
    const { id } = req.params;
    const indice = contatos.findIndex(c => c.id === id);

    if (indice === -1) {
        return res.status(404).json({ erro: "Contato não encontrado." });
    }

    contatos.splice(indice, 1);
    return res.status(204).send();
});

// Rota raiz para verificar se a API está funcionando
app.get('/', (req, res) => {
    res.json({ 
        mensagem: "API de Contatos está rodando!",
        endpoints: {
            listar: "GET /api/contatos",
            buscar: "GET /api/contatos/:id",
            criar: "POST /api/contatos",
            atualizar: "PUT /api/contatos/:id",
            deletar: "DELETE /api/contatos/:id"
        }
    });
});

// Iniciar servidor
app.listen(PORT, () => {
    console.log(`✅ Servidor rodando em http://localhost:${PORT}`);
    console.log(`📡 API disponível em http://localhost:${PORT}/api/contatos`);
});
