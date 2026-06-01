import 'package:cloud_firestore/cloud_firestore.dart';

class ClienteService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registrarCliente({
    required String nome,
    required String rua,
    required String complemento,
    required String cidade,
    required String telefone,
    required String idMotoristaResp,
    required String nomeMotoristaResp,
  }) async {
    try {
      // Telefone é único, se já ta registrado, não cria outro
      final docRef = _db.collection('clientes').doc(telefone);
      final docSnap = await docRef.get();

      // Se o telefone já existe, mostra aviso na tela e retorna
      if (docSnap.exists) {
        print("AVISO: Já existe um cliente cadastrado com o telefone $telefone!");
        // Mudar isso pra um aviso depois
        return;
      }

      // Se não existe, cria o documento normalmente
      await docRef.set({
        "nome": nome,
        "endereco": {
          "rua": rua,
          "complemento": complemento,
          "cidade": cidade,
        },
        "telefone": telefone,
        "motoristaResponsavel": {
          "id": idMotoristaResp,
          "nome": nomeMotoristaResp,
        },
        "financeiro": {
          "saldoPendente": 0.0,
          "totalComprado": 0.0,
          "ultimaEntrega": "", // Fica vazio até a primeira compra
        },
        "ultimasEntregas": [] // Array de histórico
      });
      
      print("SUCESSO: Cliente $nome salvo no banco de dados!");
    } catch (erro) {
      print("ERRO ao salvar cliente: $erro");
    }
  }

  // Retorna a lista com todos os clientes
  Future<List<Map<String, dynamic>>> buscarClientes() async {
    try {
      final snapshot = await _db.collection('clientes').get();
      return snapshot.docs.map((doc) {
        final dados = doc.data();
        dados['id'] = doc.id; // O ID aqui é o telefone
        return dados;
      }).toList();
    } catch (erro) {
      print("Erro ao buscar clientes: $erro");
      return [];
    }
  }

  // Procura por id
  Future<Map<String, dynamic>?> buscarClientePorTelefone(String telefone) async {
    try {
      final docSnap = await _db.collection('clientes').doc(telefone).get();
      
      if (docSnap.exists) {
        final dados = docSnap.data()!;
        dados['id'] = docSnap.id;
        return dados;
      }
      return null; 
    } catch (erro) {
      print("Erro ao buscar cliente específico: $erro");
      return null;
    }
  }

}