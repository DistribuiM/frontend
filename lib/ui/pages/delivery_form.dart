import 'package:flutter/material.dart';

import '../components/custom_appbar.dart';
import '../components/dropdown.dart';
import '../components/checkbox.dart';
import '../components/input.dart';

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
              Dropdown(options: [], hintText: "Motorista"),
              const SizedBox(height: 20),
              Dropdown(options: [], hintText: "Cliente"),
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
                    print(isVisible);
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
                    // adicionar caixa de imagem para comprovante de pagamento
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

class CustomSegmentedButton extends StatefulWidget {
  const CustomSegmentedButton({super.key, required this.segments, this.onSelectionChanged});
  final List<Segment> segments;
  final Function? onSelectionChanged;

  @override
  State<CustomSegmentedButton> createState() => _CustomSegmentedButtonState();
}

class _CustomSegmentedButtonState extends State<CustomSegmentedButton> {
  var index = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SegmentedButton<int>(
        style: SegmentedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.black,
          selectedForegroundColor: Colors.white,
          selectedBackgroundColor: Colors.green,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: const VisualDensity(horizontal: 0, vertical: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        segments: widget.segments.map((segment) {
          return ButtonSegment<int>(
            value: segment.value,
            label: Text(segment.label),
            icon: segment.icon == null ? null : Icon(segment.icon)
          );
        }).toList(),
        selected: <int>{index},
        onSelectionChanged: (Set<int> newSelection) {
          setState(() {
            index = newSelection.first;
          });

          widget.onSelectionChanged != null ? widget.onSelectionChanged!() : null;
        },
      ),
    );
  }
}

class Segment {
  final int value;
  final String label;
  final IconData? icon;

  const Segment({required this.value, required this.label, this.icon});
}

class DateTextField extends StatefulWidget {
  const DateTextField({super.key});

  @override
  State<DateTextField> createState() => _DateTextFieldState();
}

class _DateTextFieldState extends State<DateTextField> {
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _dateController,
      decoration: InputDecoration(
        labelText: "Data",
        filled: true,
        prefixIcon: Icon(Icons.calendar_today),
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 25,
        ),
      ),
      readOnly: true, 
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        
        if (pickedDate != null) {
          setState(() {
            // Standard formatting or use the 'intl' package for custom patterns
            _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
          });
        }
      },
    );
  }
}
