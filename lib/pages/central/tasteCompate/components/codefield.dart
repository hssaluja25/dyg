import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Displays TextField and the TextButton in a Row.
class CodeField extends StatelessWidget {
  CodeField({required this.btnText, super.key}) {
    _controller = TextEditingController(
      text: btnText == 'Copy'
          ?
          // User id
          'ewf80efjl1280vefjo'
          : '',
    );
  }
  final String btnText;
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      width: width - 80,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(5, 5),
            blurRadius: 20,
            color: Color.fromARGB(255, 148, 144, 144),
          ),
        ],
      ),
      child: Row(
        children: [
          // No need to use row alignment because I have used Expanded.
          // TextField
          Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 15),
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: TextField(
                controller: _controller,
                readOnly: btnText == 'Copy' ? true : false,
                decoration: InputDecoration(
                  hintText: btnText == 'Copy' ? '' : 'Code',
                  hintStyle: TextStyle(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  // Remove the line below the TextField when NOT in focus
                  enabledBorder: InputBorder.none,
                  // Remove the line below the TextField when in focus
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
          ),
          // The TextButton
          SizedBox(
            height: 50,
            child: TextButton(
              onPressed: () async {
                if (btnText == 'Copy') {
                  final sm = ScaffoldMessenger.of(context);
                  await Clipboard.setData(
                      ClipboardData(text: _controller.text));
                  sm
                    ..removeCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                      content: Text('Copied'),
                    ));
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const Scaffold(
                          body: Center(child: Text("Who's there?"))),
                    ),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFC2F0F2),
                foregroundColor: Colors.black,
                shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              child: Text(
                btnText,
                style: const TextStyle(
                  fontFamily: 'SyneBold',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
