import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menuautoatendimento/comp/comp_elevatedbutton.dart';
import 'package:menuautoatendimento/comp/comp_textformfield.dart';
import 'package:menuautoatendimento/models/ItemPedido.dart';
import 'package:url_launcher/url_launcher.dart';

TextEditingController _nome = TextEditingController();
TextEditingController _mesa = TextEditingController();

class SendPedido extends StatelessWidget {
  final List<ItemPedido> items;

  const SendPedido(this.items);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Cardapio Sorveteria 01'),
        ),
        body: _body());
  }

  _body() {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    _nome = TextEditingController();
    _mesa = TextEditingController();

    FocusNode _focusPass = FocusNode();

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20), // material design: 16
        child: ListView(
          children: [
            CompTextFormField(
              "Mesa", "Digite o numero da sua mesa", _mesa,
              inputType: TextInputType.number,
              inputValidator: _validate,
              inputActionNext: _focusPass,
              inputListFormatter: [
                FilteringTextInputFormatter.deny(RegExp('[#%*]'))
              ], // pode adicionar outras regras, inclusive com "allow".
            ),
            SizedBox(height: 15),
            CompTextFormField(
              "Nome",
              "Digite seu nome",
              _nome,
              inputType: TextInputType.name,
              inputValidator: _validate,
              inputFocusNode: _focusPass,
              inputAction: TextInputAction.send,
              inputActionSubmit: _onClick,
              inputMaxLength: 20,
            ),
            SizedBox(height: 15),
            Text(pedido()),
            SizedBox(height: 20),
            CompElevatedButton("Enviar pedido", _onClick,
                height: 50, fontSize: 22, colorBG: Colors.deepPurple),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Future<void> _onClick() async {
    String phone = '+55000000'; //numero do estabelecimento

    String msg = pedido();
    String nome = "Nome%20do%20cliente: " + _nome.text;
    String mesa = "%20Mesa:%20" + _mesa.text + "%0A";
    String url = 'https://api.whatsapp.com/send?phone=' +
        phone +
        '&text=Pedido%0A%0A$nome%20$mesa' +
        msg;

    print(url);

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String pedido() {
    String retorno = ' ';
    double total = 0;

    for (int i = 0; i < items.length; i++) {
      if (items.elementAt(i).qtd > 0) {
        retorno = retorno +
            '\n${items.elementAt(i).qtd}X ${items.elementAt(i).item.name} ${items.elementAt(i).item.preco}';
        total = total + items.elementAt(i).item.preco * items.elementAt(i).qtd;
      }
    }

    retorno = retorno + '\n\nTotal: RS $total';

    return retorno;
  }

  String pedidoFormat() {
    String retorno = ' ';
    double total = 0;

    for (int i = 0; i < items.length; i++) {
      if (items.elementAt(i).qtd > 0) {
        retorno = retorno +
            '%0A${items.elementAt(i).qtd}X%20${items.elementAt(i).item.name}%20${items.elementAt(i).item.preco}';
        total = total + items.elementAt(i).item.preco * items.elementAt(i).qtd;
      }
    }

    retorno += '%0ATotal%20R\$%20$total';

    return retorno;
  }

  String? _validate(dynamic text) {
    if (text.isEmpty) {
      return "Campo vazio!";
    }
    return null;
  }
}
