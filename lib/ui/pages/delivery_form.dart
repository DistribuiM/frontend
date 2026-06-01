import 'package:flutter/material.dart';

import '../components/seletor_imagem.dart';
import '../components/custom_appbar.dart';
import '../components/dropdown.dart';
import '../components/input.dart';
import '../components/segment.dart';
import '../components/segmented_button.dart';
import '../components/date_textfield.dart';
import '../../services/cliente_service.dart';
import '../../services/motorista_service.dart';

class DeliveryForm extends StatefulWidget {
  const DeliveryForm({super.key});

  @override
  State<DeliveryForm> createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  final List<Segment> segments = const [
    Segment(value: 0, label : 'Entrega de Milho', icon: Icons.local_shipping),
    Segment(value: 1, label : 'Pagamento', icon: Icons.attach_money),
  ];

  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Cadastro de Entrega', leading: true),
      backgroundColor: const Color(0xFFF7F8F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(36),
          child: Column(
            children: [
              CustomSegmentedButton(segments: segments),
              const SizedBox(height: 20),
              DateTextField(),
              const SizedBox(height: 20),

              FutureBuilder<List<Map<String, dynamic>>>(
                future: MotoristaService().buscarMotoristas(), 
                builder: (context, snapshot) {
                  
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.green));
                  }
                  
                  if (snapshot.hasError) {
                    return const Text("Erro ao carregar motoristas", style: TextStyle(color: Colors.red));
                  }

                  final listaDeMotoristas = snapshot.data ?? [];
                  List<String> nomesDosMotoristas = listaDeMotoristas.map((motorista) => motorista['nome'] as String).toList();

                  return Dropdown(
                    options: nomesDosMotoristas, 
                    hintText: "Motorista"
                  );
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: ClienteService().buscarClientes(), 
                builder: (context, snapshot) {
                
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Colors.green));
                }
                
                if (snapshot.hasError) {
                  return const Text("Erro ao carregar clientes", style: TextStyle(color: Colors.red));
                }

                final listaDeClientes = snapshot.data ?? [];
                
                List<String> nomesDosClientes = listaDeClientes.map((cliente) => cliente['nome'] as String).toList();

                return Dropdown(
                  options: nomesDosClientes, 
                  hintText: "Cliente"
                );
              },
            ),
              const SizedBox(height: 20),
              Dropdown(options: ["Endereço do cliente", "Galpão", "Feira"], hintText: "Local da Entrega"),
              const SizedBox(height: 20),
              Input(label: 'Quantidade de Milho', hintText: '', numberInput: true),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                alignment: Alignment.centerLeft, 
                child: const Text("Preço do Milho")
              ),
              CustomSegmentedButton(segments: [Segment(value: 70, label: '70,00'), Segment(value: 80, label: '80,00')]),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(bottom: 8),
                alignment: Alignment.centerLeft, 
                child: const Text("Cliente fez algum pagamento?")
              ),
              CustomSegmentedButton(segments: [
                Segment(value: 0, label: 'Não'), 
                Segment(value: 1, label: 'Sim')
                ],
                onSelectionChanged: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                }
              ),
              const SizedBox(height: 20),
              Visibility(
                visible: isVisible, 
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 8),
                      alignment: Alignment.centerLeft, 
                      child: const Text("Forma de pagamento")
                    ),
                    CustomSegmentedButton(segments: [Segment(value: 0, label: 'Dinheiro'), Segment(value: 1, label: 'Pix'), Segment(value: 2, label: 'Cartão')]),
                    const SizedBox(height: 20),
                    Input(label: 'Valor pago', hintText: '', numberInput: true),
                    const SizedBox(height: 20),
                    SeletorImagem(onImageSelected: (imagemSelecionada){
                      // Vai imprimir no terminal o caminho da foto, 
                      // indicando que a foto foi capturada
                      print ("Foto capturada com sucesso: ${imagemSelecionada.path}");
                    },),
                    const SizedBox(height: 20),
                  ]
                )
              ),
              Input(label: 'Observação', hintText: ''),

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