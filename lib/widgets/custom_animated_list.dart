import 'package:app_grupal/helpers/constants.dart';
import 'package:app_grupal/models/list_tile_model.dart';
import 'package:flutter/material.dart';

class CustomAnimatedList extends StatelessWidget {
  const CustomAnimatedList({
    Key key,
    @required this.lista
  }) : super(key: key);

  final List<ListTileModel> lista;

  @override
  Widget build(BuildContext context) {
    int _itemsAnimated = 0;
    final GlobalKey<AnimatedListState> _key = GlobalKey();

    return _listaAnimada(_itemsAnimated, _key);
  }

  Widget _listaAnimada(int _itemsAnimated, GlobalKey<AnimatedListState>_key){
    _insertItem(_itemsAnimated, _key);
    return AnimatedList(
      key: _key,
      initialItemCount: _itemsAnimated,
      itemBuilder: (context, index, animation){
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(1, 0), end: Offset.zero).animate(animation),
          child: _listTile(lista[index]),
        );
      },
    );
  }

  Widget _listTile(ListTileModel item){
    return Card(
      child: ListTile(
        title: Text(item.title, style: Constants.mensajeCentral, overflow: TextOverflow.ellipsis),
        subtitle: Text(item.subtitle, overflow: TextOverflow.ellipsis),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            item.leading
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            item.trailing
          ],
        ),
        isThreeLine: true,
        
      ),
    );
  }

  _insertItem(int _itemsAnimated, GlobalKey<AnimatedListState>_key) async{
    await Future.delayed(Duration(milliseconds:450));
    for(int i=0; i<lista.length; i++){
      if(_key.currentState != null) _key.currentState.insertItem(i);
      _itemsAnimated++;
      await Future.delayed(Duration(milliseconds:225));
    }
  }
}