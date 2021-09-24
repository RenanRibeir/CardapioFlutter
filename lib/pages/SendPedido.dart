import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:menuautoatendimento/comp/comp_elevatedbutton.dart';
import 'package:menuautoatendimento/comp/comp_textformfield.dart';
import 'package:menuautoatendimento/models/ItemPedido.dart';
import 'package:url_launcher/url_launcher.dart';

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
    // key: identificador de cada componente
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    // OBS: útil em testes, se quiser já autopreencher, usar o arg text
    TextEditingController _contEmail = TextEditingController();
    TextEditingController _contPass = TextEditingController();
    FocusNode _focusPass = FocusNode();

    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(20), // material design: 16
        child: ListView(
          children: [
            CompTextFormField(
              "Mesa", "Digite o numero da sua mesa", _contEmail,
              inputType: TextInputType.emailAddress,
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
              _contPass,
              inputType: TextInputType.number,
              inputObscure: true,
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

    String phone = '+55000000';
    String msg = pedido();

    String url = 'https://api.whatsapp.com/send?phone=' + phone +'&text=Pedido%0A' +msg+ ' _blank';

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
