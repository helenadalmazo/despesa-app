import 'dart:developer';

import 'package:despesa_app/extensions/string_extensions.dart';
import 'package:flutter/material.dart';

class ExpenseCategory {
  final int id;
  final String group;
  final String name;

  ExpenseCategory({
    this.id,
    this.group,
    this.name
  });

  factory ExpenseCategory.fromJson(Map<String, dynamic> json) {
    return ExpenseCategory(
        id: json["id"],
        group: json["group"],
        name: json["name"]
    );
  }

  String getEmoji() {
    MapEntry<String, Map<String, dynamic>> emoji = _list
        .entries
        .firstWhere((entry) => entry.key == this.name, orElse: () => null);

    if (emoji != null) return emoji.value["emoji"];

    log("Emoji não localizado para categoria de despesa. grupo [${this.group}], nome [${this.name}]");
    return _generalEmoji;
  }

  static String getSuggestion(String value) {
    value = value.removeDiacritics().toLowerCase();

    for (MapEntry<String, Map<String, dynamic>> entry in _list.entries) {
      if (entry.key.removeDiacritics().toLowerCase() == value) return entry.key;

      String suggestion = entry.value["suggestion"].firstWhere((string) {
        return value.contains(string.toString().removeDiacritics().toLowerCase());
      }, orElse:() => null);

      if (suggestion != null) return entry.key;
    }

    return "Outros";
  }

  static Color getColor(String group) {
    switch (group) {
      case "Alimentação":
        return Colors.redAccent;
      case "Educação":
        return Colors.greenAccent;
      case "Entretenimento e lazer":
        return Colors.purpleAccent;
      case "Moradia":
        return Colors.orangeAccent;
      case "Saúde":
        return Colors.blueAccent;
      case "Serviços":
        return Colors.indigoAccent;
      case "Transporte":
        return Colors.lime;
      case "Outros":
        return Colors.blueGrey;
      default:
        return Colors.blueGrey;
    }
  }

  static String _generalEmoji = "\u{1F4C4}";

  static Map<String, Map<String, dynamic>> _list = {
    "Mercado": {
      "emoji": "\u{1F6D2}",
      "suggestion": []
    },
    "Restaurantes": {
      "emoji": "\u{1F37D}",
      "suggestion": ["Marmita", "Delivery"],
    },
    "Escola": {
      "emoji": "\u{1F392}",
      "suggestion": [],
    },
    "Materiais": {
      "emoji": "\u{1F4DA}",
      "suggestion": ["Cadernos", "Livros", "Apostila"],
    },
    "Eventos": {
      "emoji": "\u{1F389}",
      "suggestion": ["Festa", "Aniversário"],
    },
    "Filmes": {
      "emoji": "\u{1F3A5}",
      "suggestion": ["Cinema", "Netflix", "Amazon", "Disney"],
    },
    "Jogos": {
      "emoji": "\u{1F3B2}", // 1F9E9
      "suggestion": [],
    },
    "Viagens": {
      "emoji": "\u{1F5FA}", // 1F3DD
      "suggestion": [],
    },
    "Aluguel": {
      "emoji": "\u{1F3D8}",
      "suggestion": [],
    },
    "Eletrônicos": {
      "emoji": "\u{1F4FA}",
      "suggestion": [
        "Fogão",
        "Geladeira",
        "Máquina de lavar",
        "Microondas",
        "Aspirador"
      ],
    },
    "Manutenção": {
      "emoji": "\u{1F527}", // 1F6CB
      "suggestion": ["Eletricista", "Pedreiro", "Encanador"],
    },
    "Móveis": {
      "emoji": "\u{1F6CF}",
      "suggestion": [
        "Sofá",
        "Mesa",
        "Cadeira",
        "Estante",
        "Escrivaninha",
        "Cama",
        "Guarda roupa"
      ],
    },
    "Despesas médicas": {
      "emoji": "\u{1F489}",
      "suggestion": ["Consulta", "Dentista", "Periódico", "Exame"],
    },
    "Farmácia": {
      "emoji": "\u{1F48A}",
      "suggestion": [],
    },
    "Água": {
      "emoji": "\u{1F4A7}",
      "suggestion": [],
    },
    "Eletricidade": {
      "emoji": "\u{1F4A1}",
      "suggestion": ["Energia", "Elétrica", "Luz"],
    },
    "Gás": {
      "emoji": _generalEmoji,
      "suggestion": ["Botijão"],
    },
    "Impostos": {
      "emoji": _generalEmoji,
      "suggestion": [],
    },
    "TV/Telefone/Internet": {
      "emoji": "\u{1F4F1}",
      "suggestion": [
        "Televisão",
        "Telefone",
        "Celular",
        "Internet",
        "Wi-fi"
      ],
    },
    "Avião": {
      "emoji": "\u{2708}",
      "suggestion": ["Passagem"],
    },
    "Bicicleta": {
      "emoji": "\u{1F6B2}",
      "suggestion": [],
    },
    "Carro": {
      "emoji": "\u{1F697}",
      "suggestion": [],
    },
    "Combustível": {
      "emoji": "\u{26FD}",
      "suggestion": ["Gasolina", "Álcool", "Gás natural"],
    },
    "Estacionamento": {
      "emoji": "\u{26D4}",
      "suggestion": [],
    },
    "Seguro": {
      "emoji": _generalEmoji,
      "suggestion": [],
    },
    "Táxi": {
      "emoji": "\u{1F695}",
      "suggestion": ["Uber"],
    },
    "Transporte público": {
      "emoji": "\u{1F68C}",
      "suggestion": [],
    },
    "Outros": {
      "emoji": _generalEmoji,
      "suggestion": [],
    }
  };
}