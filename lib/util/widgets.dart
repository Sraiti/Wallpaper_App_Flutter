import 'package:flutter/material.dart';

class ShowMore extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  ShowMore({@required this.text, @required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 22.0,
              fontFamily: 'Caveat',
            ),
          ),
        ),
        FlatButton(
          color: Colors.grey,
          child: Text(
            'See all Favorites',
            style: TextStyle(
              fontSize: 12.0,
              fontFamily: 'good2',
            ),
          ),
          onPressed: onTap,
        )
      ],
    );
  }
}
