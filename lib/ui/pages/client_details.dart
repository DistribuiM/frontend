import 'package:flutter/material.dart';
import '../../services/entrega_service.dart';
import '../components/custom_appbar.dart';

class ClientePage extends StatefulWidget {
  final Map<String, dynamic> cliente;

  const ClientePage({super.key, required this.cliente});

  @override
  State<ClientePage> createState() => _ClientePageState();
}

class _ClientePageState extends State<ClientePage> {
  final EntregaService _entregaService = EntregaService();

  @override
  Widget build(BuildContext context) {
    final cliente = widget.cliente;
    final endereco = cliente['endereco'];
    final financeiro = cliente['financeiro'];
    final motoristaResp = cliente['motoristaResponsavel'];

    return Scaffold(
      appBar: CustomAppBar(title: 'Ficha do Cliente', leading: true),
      backgroundColor: const Color(0xFFF7F8F5),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Nome do cliente
              _Label(text: "Cliente"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person, color: Colors.green[700], size: 28),
                      const SizedBox(width: 8),
                      Text(
                        cliente['nome'],
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {}, // abrir formulário de entrega
                    icon: Icon(Icons.add, color: Colors.green[700], size: 28),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 12),

              // Valor pendente
              _Label(text: "Valor Pendente do Cliente"),
              Text(
                "R\$${financeiro['saldoPendente'].toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),

              // Endereço
              _Label(text: "Endereço"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "${endereco['rua']}${endereco['complemento'].isNotEmpty ? ', ${endereco['complemento']}' : ''}",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  Icon(Icons.location_on, color: Colors.grey[600]),
                ],
              ),
              const SizedBox(height: 20),

              // Cidade
              _Label(text: "Cidade"),
              Text(endereco['cidade'], style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),

              // Telefone
              _Label(text: "Telefone"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cliente['telefone'], style: const TextStyle(fontSize: 16)),
                  Row(
                    children: [
                      Icon(Icons.phone, color: Colors.grey[600]),
                      const SizedBox(width: 8),
                      Icon(Icons.chat_bubble, color: Colors.grey[600]),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Motorista responsável
              _Label(text: "Motorista Responsável"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.local_shipping, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      Text(
                        motoristaResp['nome'],
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey[600], size: 18),
                ],
              ),
              const SizedBox(height: 24),
              const Divider(),

              // Tabela de entregas
              StreamBuilder(
                stream: _entregaService.ouvirEntregasDoCliente(cliente['id']),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Colors.green));
                  }

                  if (snapshot.hasError) {
                    return const Text("Erro ao carregar entregas", style: TextStyle(color: Colors.red));
                  }

                  final todasEntregas = snapshot.data!.docs
                      .map((doc) => doc.data() as Map<String, dynamic>)
                      .toList();

                  final ultimas5 = todasEntregas.take(5).toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "Entregas",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "${todasEntregas.length}",
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStatePropertyAll(Colors.grey[100]),
                          columns: const [
                            DataColumn(label: Text("Data", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Qtd.", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Valor Pago", style: TextStyle(fontWeight: FontWeight.bold))),
                            DataColumn(label: Text("Pendente", style: TextStyle(fontWeight: FontWeight.bold))),
                          ],
                          rows: ultimas5.map((entrega) {
                            final financeiro = entrega['financeiro'];
                            final pago = entrega['status']['pago'] as bool;
                            return DataRow(cells: [
                              DataCell(Text(entrega['dataEntrega'])),
                              DataCell(Text("${entrega['quantidadeSacos']}")),
                              DataCell(Text(
                                "R\$${financeiro['valorPago'].toStringAsFixed(2)}",
                                style: TextStyle(color: pago ? Colors.green[700] : Colors.red[700]),
                              )),
                              DataCell(Text(
                                "R\$${financeiro['valorPendente'].toStringAsFixed(2)}",
                                style: TextStyle(color: pago ? Colors.green[700] : Colors.red[700]),
                              )),
                            ]);
                          }).toList(),
                        ),
                      ),

                      if (todasEntregas.length > 5)
                        TextButton(
                          onPressed: () {}, // redirecionar para tela de entregas filtrada
                          child: Text(
                            "Ver mais",
                            style: TextStyle(color: Colors.green[700], fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// labels cinzas
class _Label extends StatelessWidget {
  final String text;
  const _Label({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
      ),
    );
  }
}