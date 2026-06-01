import 'package:cloud_firestore/cloud_firestore.dart';

class MotoristaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registrarMotorista({
    required String nome,
    required String telefone,
    required String email,
  }) async {
    try {
      // O email é único, se já ta registrado, não registra motorista novo
      final docRef = _db.collection('motoristas').doc(email);
      final docSnap = await docRef.get();

      if (docSnap.exists) {
        // Se já existe, a criação é bloqueada
        print("AVISO: Já existe um motorista cadastrado com o e-mail $email!");
        return;
      }

      // Se não existe, o documento é criado normalmente
      await docRef.set({
        "nome": nome,
        "telefone": telefone,
        "email": email,
        "stats": {
          "clientesAtivos": 0,
          "entregasHoje": 0,
          "valorReceber": 0.0
        }
      });
      
      print("Motorista $nome salvo com sucesso!"); // Para Debug
    } catch (erro) {
      print("Erro ao salvar motorista: $erro"); // Para Debug
    }
  }

  // Retorna uma lista de todos os motoristas
  Future<List<Map<String, dynamic>>> buscarMotoristas() async {
    try {
      final snapshot = await _db.collection('motoristas').get();
      return snapshot.docs.map((doc) {
        final dados = doc.data();
        dados['id'] = doc.id; // O ID aqui é o e-mail
        return dados;
      }).toList();
    } catch (erro) {
      print("Erro ao buscar motoristas: $erro");
      return [];
    }
  }

  // Procura por id
  Future<Map<String, dynamic>?> buscarMotoristaPorId(String email) async {
    try {
      final docSnap = await _db.collection('motoristas').doc(email).get();
      
      if (docSnap.exists) {
        final dados = docSnap.data()!;
        dados['id'] = docSnap.id;
        return dados;
      }
      return null; // Retorna nulo se o motorista não existir
    } catch (erro) {
      print("Erro ao buscar motorista específico: $erro");
      return null;
    }
  }
  
}