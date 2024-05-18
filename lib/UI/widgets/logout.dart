import 'package:flutter/material.dart';

class BuildLoggedOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue.shade900, width: 2.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning,
              color: Colors.blue.shade900,
            ),
            SizedBox(width: 10.0),
            Text(
              "Effettua il login per accedere al carrello",
              style: TextStyle(
                fontSize: 20,
                color: Colors.blue.shade900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
