import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dyg/pages/central/tasteCompate/results/results.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../services/API/check_valid_spotify_user.dart';
import '../../../../services/API/get_following.dart';

/// Displays TextField and the TextButton in a Row.
class CodeField extends StatefulWidget {
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
  State<CodeField> createState() => _CodeFieldState();
}

class _CodeFieldState extends State<CodeField> {
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
                controller: widget._controller,
                readOnly: widget.btnText == 'Copy' ? true : false,
                decoration: InputDecoration(
                  hintText: widget.btnText == 'Copy' ? '' : 'Code',
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
                if (widget.btnText == 'Copy') {
                  final sm = ScaffoldMessenger.of(context);
                  await Clipboard.setData(
                      ClipboardData(text: widget._controller.text));
                  sm
                    ..removeCurrentSnackBar()
                    ..showSnackBar(const SnackBar(
                      content: Text('Copied'),
                    ));
                }
                // The lower code field
                else {
                  final String friendCode = widget._controller.text;
                  if (friendCode == '') {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text('Cannot be empty'),
                        ),
                      );
                  } else if (friendCode == widget.userId) {
                    ScaffoldMessenger.of(context)
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text(
                              'You cannot compare music taste with yourself'),
                        ),
                      );
                  } else {
                    /// result = [false] if userId is invalid
                    /// result = [true, friendName, img] is userId is valid
                    final List<dynamic> result = await checkValidUser(
                      userId: widget._controller.text,
                      accessToken: widget.accessToken,
                      refreshToken: widget.refreshToken,
                    );
                    // Not a valid Spotify id
                    if (!result[0]) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text('Friend id is not valid'),
                          ),
                        );
                    }
                    // A valid spotify id was entered.
                    else {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text('Loading'),
                          ),
                        );
                      // Checks if friend exists on firestore (i.e., has Dyg installed)
                      print('Checking if user exists on firestore.');
                      final userRef = FirebaseFirestore.instance
                          .collection('top tracks & artists')
                          .doc(widget._controller.text);
                      final snapshot = await userRef.get();
                      if (!mounted) return;
                      if (snapshot.exists) {
                        print('User exists on firestore');
                        print(
                            'Friend id is valid and user exists on firestore');
                        // Stores the artists followed by the friend
                        List friendFollowing = snapshot.data()!['following'];
                        String friendName = result[1];
                        String img = result[2];

                        List following = await getFollowing(
                            accessToken: widget.accessToken,
                            refreshToken: widget.refreshToken);
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => Scaffold(
                              body: Results(
                                following: following,
                                friendFollowing: friendFollowing,
                                friendName: friendName,
                                img: img,
                              ),
                            ),
                          ),
                        );
                      } else {
                        print('User does not exist on firestore');
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'The associated account does not have dyg installed.'),
                            ),
                          );
                      }
                    }
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
                widget.btnText,
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
