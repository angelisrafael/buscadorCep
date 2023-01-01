import 'dart:convert';

class EnderecoModel {
  final String cep;
  final String logradouro;
  final String complemento;
  final String bairro;

  EnderecoModel({
    required this.cep,
    required this.logradouro,
    required this.complemento,
    required this.bairro,
  });

  Map<String, dynamic> toMap() {
    return {'cep': cep, 'logradouro': logradouro, 'complemento': complemento, 'bairro' : bairro};
  }

  factory EnderecoModel.fromMap(Map<String, dynamic> map) {
    return EnderecoModel(
        cep: map['cep'],
        logradouro: map['logradouro'],
        complemento: map['complemento'],
        bairro: map['bairro']);
  }

  factory EnderecoModel.fromJson(String json) =>
      EnderecoModel.fromMap(jsonDecode(json));
}
