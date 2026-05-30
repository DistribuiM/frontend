import 'package:flutter/material.dart';
import '../components/custom_appbar.dart';
import '../components/dropdown.dart';
import '../components/input.dart';
import '../components/checkbox.dart';

class ClientForm extends StatelessWidget {
  final List <String> _cities = ['Santos', 'São Vicente', 'Guarujá', 'Praia Grande', 'Cubatão', 'Bertioga', 'Mongaguá', 'Itanhaém'];
  ClientForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Cadastro de Cliente', leading: true),
      backgroundColor: const Color(0xFFF7F8F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(36),
          child: Column(
            children: [
              Input(label: 'Nome', hintText: 'Digite o nome do cliente'),
              const SizedBox(height: 20),
              Input(label: 'Endereço', hintText: 'Digite o endereço do cliente'),
              const SizedBox(height: 20),
              Dropdown(options: _cities, hintText: 'Cidade'),
              const SizedBox(height: 20),
              Input(label: 'Telefone', hintText: 'Digite o telefone do cliente'),
              const SizedBox(height: 20),
              Input(label: 'Complemento ou ponto de referência', hintText: 'Digite o complemento ou ponto de referência do cliente'),
              const SizedBox(height: 20),
              CheckBox(label: "Pode vender fiado para o cliente?")
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              backgroundColor: const Color(0xFF4D7C42),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Salvar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        )
      ),
    );
  }
}