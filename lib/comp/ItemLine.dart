import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:menuautoatendimento/models/Item.dart';
import 'package:menuautoatendimento/pages/ItemsPage.dart';

// StatefulWidget : componente cujo estado pode ser alterado.
class ItemLine extends StatefulWidget {
  final Item item;

  const ItemLine(this.item);

  @override
  _ItemLine createState() => _ItemLine();
}

class _ItemLine extends State<ItemLine> {
  int qtd = 0;

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(backgroundImage: NetworkImage(widget.item.img));

    return ListTile(
      leading: avatar,
      title: Text(widget.item.name),
      subtitle: Text(widget.item.preco.toString()),
      trailing: Container(
        width: 120,
        child: Row(
          children: <Widget>[
            IconButton(
                onPressed: () {
                  if (qtd > 0) {
                    setState(() {
                      qtd = qtd - 1;
                    });
                    ItemsPage.decrementarItem(int.parse(widget.item.id));
                  }
                },
                icon: Icon(Icons.exposure_minus_1)),
            Text(qtd.toString()),
            IconButton(
                onPressed: () {
                  setState(() {
                    qtd = qtd + 1;
                  });
                  ItemsPage.incrementarItem(int.parse(widget.item.id));
                },
                icon: Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}
