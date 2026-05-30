import 'package:flutter/material.dart';

class ClientList extends StatefulWidget {
  const ClientList({super.key});

  @override
  State<ClientList> createState() => ClientListState();
}

class ClientListState extends State<ClientList> {
  // Lista inicial, no projeto final não vai ter nada, é só pra teste
  final List<City> _clientsByCity = [
    City(
      cityName: "Praia Grande",
      clients: [
        Client(name: "João", address: "Rua A, 123"),
        Client(name: "Carlos", address: "Rua B, 456"),
      ],
    ),
    City(
      cityName: "Santos",
      clients: [
        Client(name: "Maria", address: "Rua C, 789"),
      ],
    ),
  ];

  void adicionarCliente() {
    setState(() {
      // Dados de exemplo (depois vai ter um formulário real)
      String cidadeAlvo = "São Vicente"; 
      String nomeCliente = "Novo Cliente Genérico";
      String enderecoCliente = "Rua Genérica, 123";

      // Procura se a cidade alvo já existe na lista
      final index = _clientsByCity.indexWhere((cidade) => 
          cidade.cityName.toLowerCase() == cidadeAlvo.toLowerCase());

      if (index != -1) {
        // Se existe, só adiciona o cliente na cidade
        _clientsByCity[index].clients.add(
          Client(name: nomeCliente, address: enderecoCliente)
        );
      } else {
        // Se não existe, cria a cidade e adiciona o cliente nela
        _clientsByCity.add(
          City(
            cityName: cidadeAlvo, 
            clients: [
              Client(name: nomeCliente, address: enderecoCliente),
            ],
          ),
        );
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _clientsByCity.map((city) {
        return Column(
          children: [
            ClientListHeader(city: city),
            ...city.clients.map((client) {
              return Column(
                children: [
                  ClientListClients(client: client),
                  const Divider(height: 1, thickness: 1, color: Color.fromARGB(120, 158, 158, 158)),
                ],
              );
            }),
          ],
        );
      }).toList(),
    );
  }
}

class ClientListHeader extends StatelessWidget {
  final City city;
  const ClientListHeader({super.key, required this.city});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.grey[200],
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),
      child: Row(
        children: [
          Text(
            city.cityName,
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "R\$0.00",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class ClientListClients extends StatelessWidget {
  final Client client;
  const ClientListClients({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // lado esquerdo com nome e endereço
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.group, color: Colors.green[700]),
                        const SizedBox(width: 8),
                        Text(
                          client.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      client.address,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),

              // preço do lado direito
              const Text(
                "R\$0.00",
                style: TextStyle(
                  color: Color.fromARGB(255, 212, 30, 17),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // botões
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.phone),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.chat_bubble),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class City {
  final String cityName;
  final List<Client> clients;

  City({
    required this.cityName,
    required this.clients,
  });
}

class Client {
  final String name;
  final String address;

  Client({required this.name, required this.address});
}