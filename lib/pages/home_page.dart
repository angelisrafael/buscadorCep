import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import '../models/endereco_model.dart';
import '../repositories/cep_repository.dart';
import '../repositories/cep_repository_impl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CepRepository cepRepository = CepRepositoryImpl();
  EnderecoModel? enderecoModel;
  bool loading = false;

  final formKey = GlobalKey<FormState>();
  final cepEC = TextEditingController();

  @override
  void dispose() {
    cepEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 40),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    const Gap(80),
                    Container(
                      height: 130,
                      width: 130,
                      decoration: const BoxDecoration(
                        image: DecorationImage(fit: BoxFit.fitHeight,
                          image: AssetImage("assets/images/cep_img.png"))
                      ),
                    ),
                    const Gap(50),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      style: const TextStyle(fontSize: 18),
                      decoration: const InputDecoration(
                        labelText: 'Digite um CEP',
                        border: OutlineInputBorder()
                      ),
                      controller: cepEC,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'CEP obrigatório';
                        }
                        return null;
                      },
                    ),
                    const Gap(30),
                    ElevatedButton(
                        onPressed: () async {
                          final valid =
                              formKey.currentState?.validate() ?? false;
                          if (valid) {
                            try {
                              setState(() {
                                loading = true;
                              });
                              final endereco =
                                  await cepRepository.getCep(cepEC.text);
                              setState(() {
                                loading = false;
                                enderecoModel = endereco;
                              });
                            } catch (e) {
                              setState(() {
                                loading = false;
                                enderecoModel = null;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Erro ao buscar Endereço')));
                            }
                          }
                        },
                        child: const Text('Buscar')),
                    Visibility(
                        visible: loading,
                        child: const CircularProgressIndicator()),
                    const Gap(30),
                    Visibility(
                        visible: enderecoModel != null,
                        child: Text(
                            'Bairro: ${enderecoModel?.bairro}\n Rua: ${enderecoModel?.logradouro}\n Complemento: ${enderecoModel?.complemento}\n CEP: ${enderecoModel?.cep}'))
                  ],
                ))));
  }
}
