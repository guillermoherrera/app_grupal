import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class CardSwiper extends StatelessWidget {
  const CardSwiper({
    Key key, 
    @required this.listItems
  }) : super(key: key);

  final List<Widget> listItems;

  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Swiper(
        itemBuilder: (BuildContext context,int index){

          return ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: listItems[index]
          );
        },
        itemCount: listItems.length,
        itemWidth: _screenSize.width * 0.7,
        itemHeight: _screenSize.height * 0.5,
        layout: SwiperLayout.STACK,
        
        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
      ),
    );
  }
}