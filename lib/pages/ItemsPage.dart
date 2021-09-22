import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menuautoatendimento/comp/ItemLine.dart';
import 'package:menuautoatendimento/comp/comp_elevatedbutton.dart';
import 'package:menuautoatendimento/comp/comp_textformfield.dart';
import 'package:menuautoatendimento/data/Cardapio.dart';
import 'package:menuautoatendimento/models/ItemPedido.dart';
import 'package:menuautoatendimento/pages/SendPedido.dart';

class ItemsPage extends StatelessWidget {
  late BuildContext cont;
  static late List<ItemPedido> pedido = [];

  @override
  Widget build(BuildContext context) {
    const items = {...Cardapio};
    cont = context;
    return Scaffold(
        appBar: AppBar(
          title: Text('Cardapio Sorveteria 01'),
        ),
        body: _list(items));
  }

  void _onClick() async {
    try {
      await push(cont, SendPedido(pedido));
    } catch (error) {
      print(error.toString());
    }
  }

  _list(var items) {
    pedidos();
    return Container(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, i) => ItemLine(items.values.elementAt(i)),
            ),
          ),
          CompElevatedButton("Enviar pedido", _onClick,
              height: 50, fontSize: 22, colorBG: Colors.deepPurple),
        ],
      ),
    );
  }

  void pedidos() {
    const items = {...Cardapio};
    for (int i = 0; i < items.length; i++) {
      pedido.add(ItemPedido(item: items.values.elementAt(i), qtd: 0));
    }
  }

  static void incrementarItem(int id) {
    pedido.elementAt(id).qtd = pedido.elementAt(id).qtd + 1;
  }

  static void decrementarItem(int id) {
    pedido.elementAt(id).qtd = pedido.elementAt(id).qtd - 1;
  }

  Future push(BuildContext context, Widget page, {bool flagBack = true}) {
    if (flagBack) {
      // Pode voltar, ou seja, a página é adicionada na pilha.
      return Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }));
    } else {
      // Não pode voltar, ou seja, a página nova substitui a página atual.
      return Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return page;
      }));
    }
  }

  String? _validate(dynamic text) {
    if (text.isEmpty) {
      return "Campo vazio!";
    }
    return null;
  }
}
