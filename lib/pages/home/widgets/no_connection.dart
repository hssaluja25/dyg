import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  const NoConnection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            flex: 5,
            child: Image.asset('assets/images/no_internet.jpg'),
          ),
          const Expanded(
            flex: 2,
            child: Text(
              'No Internet Connection',
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
