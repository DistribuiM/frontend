import 'package:flutter/material.dart';

class DeliveryList extends StatefulWidget {
  const DeliveryList({super.key});

  @override
  State<DeliveryList> createState() => DeliveryListState();
}

class DeliveryListState extends State<DeliveryList> {
  final List<Delivery> _entregas = [
    Delivery(title: 'Entrega 1 - Endereço a definir', status: 'Pendente'),
    Delivery(title: 'Entrega 2 - Endereço a definir', status: 'Pendente'),
    Delivery(title: 'Entrega 3 - Endereço a definir', status: 'Pendente'),
  ];

  void adicionarEntrega() {
    // Essa função vai conectar com o backend pra pegar as informações necessárias da entrega
    // Como nome do cliente e endereço
    setState(() {
      _entregas.add(Delivery(title: 'Entrega ${_entregas.length + 1} - Endereço a definir', status: 'Pendente'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _entregas.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 2,
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.local_shipping, color: Colors.white, size: 20),
            ),
            title: Text(
              _entregas[index].title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_entregas[index].status),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        );
      },
    );
  }
}

class Delivery {
  final String title;
  final String status;

  Delivery({required this.title, required this.status});
}