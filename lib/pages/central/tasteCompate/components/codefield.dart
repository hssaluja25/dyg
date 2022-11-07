import 'package:dyg/pages/central/tasteCompate/results/results.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../services/API/check_valid_spotify_user.dart';
import '../../../../services/firestore/user_exists_on_firestore.dart';

/// Displays TextField and the TextButton in a Row.
class CodeField extends StatelessWidget {
  CodeField(
      {required this.btnText,
      required this.userId,
      required this.accessToken,
      required this.refreshToken,
      super.key}) {
    _controller = TextEditingController(
      text: btnText == 'Copy' ? userId : '',
    );
  }
  final String accessToken;
  final String refreshToken;
  final String btnText;
  final String userId;
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
                // The upper code field
                if (btnText == 'Copy') {
                  final sm = ScaffoldMessenger.of(context);
                  await Clipboard.setData(
                      ClipboardData(text: _controller.text));
                  sm
                    ..removeCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                      content: Text('Copied'),
                    ));
                }
                // The lower code field
                else {
                  final String friendCode = _controller.text;
                  if (friendCode == '') {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text('Cannot be empty'),
                        ),
                      );
                  } else if (friendCode == userId) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text(
                              'You cannot compare music taste with yourself'),
                        ),
                      );
                  } else if (!(await checkValidUser(
                    userId: _controller.text,
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                  ))) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text('Friend id is not valid'),
                        ),
                      );
                  } else if (!(await checkUserExists(userId: userId))) {
                    print('User does not exist on firestore');
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text(
                              'The associated account does not have dyg installed.'),
                        ),
                      );
                  } else {
                    print('Friend id is valid and user exists on firestore');
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const Scaffold(
                          body: Results(value: 0.6),
                        ),
                      ),
                    );
                  }
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
