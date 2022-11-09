import 'package:auto_size_text/auto_size_text.dart';
import 'package:dyg/services/find_common_artists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Results extends StatefulWidget {
  Results({
    required this.friendName,
    required this.img,
    required this.following,
    required this.friendFollowing,
    super.key,
  });
  final List following;
  final List friendFollowing;
  final String friendName;
  final String img;

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  // Empty if there is no match
  late List commonArtists;
  double match = 0;

  @override
  void initState() {
    super.initState();
    List comparisonResult = compare(
      following: widget.following,
      friendFollowing: widget.friendFollowing,
    );
    commonArtists = comparisonResult.sublist(0, comparisonResult.length - 1);
    match = comparisonResult[comparisonResult.length - 1];
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(statusBarColor: Colors.black),
      child: SafeArea(
        child: Container(
          color: Colors.black,
          child: Stack(
            children: [
              // Back button
              Positioned(
                top: 0.0479 * height,
                left: 0.05089 * width,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              // User Image
              widget.img != 'Unavailable'
                  ? Positioned(
                      top: 0.11976 * height,
                      left: (width / 2) - 100,
                      child: CircleAvatar(
                        foregroundImage: NetworkImage(widget.img),
                        radius: 100,
                      ),
                    )
                  : Positioned(
                      top: 0.11976 * height,
                      left: (width / 2) - 100,
                      child: const CircleAvatar(
                        foregroundImage:
                            AssetImage('assets/images/results/placeholder.png'),
                        radius: 100,
                      ),
                    ),
              // The top dash line
              Positioned(
                top: 0.0479 * height,
                right: 0.076336 * width,
                child: Container(
                  color: Colors.white,
                  height: 0.00359 * height,
                  width: 0.15267 * width,
                ),
              ),
              // The bottom dash line
              Positioned(
                top: 0.05988 * height,
                right: 0.15267 * width,
                child: Container(
                  color: Colors.white,
                  height: 0.00359 * height,
                  width: 0.12723 * width,
                ),
              ),
              // The short dash line at the bottom
              Positioned(
                top: 0.05988 * height,
                right: 0.12723 * width,
                child: Container(
                  color: Colors.white,
                  height: 0.00359 * height,
                  width: 0.012723 * width,
                ),
              ),
              // Main Content
              Positioned(
                top: height / 3 + 50,
                child: SizedBox(
                  height: 2 * height / 3 - 80,
                  width: width,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    addAutomaticKeepAlives: true,
                    cacheExtent: 100,
                    itemCount:
                        // commonArtists would be empty if there was no match between user and friend
                        commonArtists.isEmpty ? 3 : commonArtists.length + 4,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        // Comparing with <friend name> heading
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 0.05089 * width),
                          child: AutoSizeText(
                            'Comparing with ${widget.friendName}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Draft',
                              fontSize: 30,
                            ),
                            maxLines: 1,
                          ),
                        );
                      } else if (index == 1) {
                        // The Graph along with the text in the middle
                        return Container(
                          margin: EdgeInsets.only(top: 0.02994 * height),
                          child: Stack(
                            alignment: const Alignment(0, 0),
                            children: [
                              // The circular graph
                              SizedBox(
                                height: 0.2994 * height,
                                width: 0.63613 * width,
                                child: Center(
                                  child: SizedBox(
                                    height: 0.263473 * height,
                                    width: 0.559796 * width,
                                    child: CircularProgressIndicator(
                                      value: match / 100,
                                      color: const Color(0xFF28c45c),
                                      backgroundColor: const Color(0xFF181c24),
                                      strokeWidth: 10,
                                    ),
                                  ),
                                ),
                              ),
                              // Value% in the center of the graph
                              Text(
                                '${match.toInt()}%',
                                style: const TextStyle(
                                  fontSize: 60,
                                  fontFamily: 'Syne',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (index == 2) {
                        // Match: value%
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 0.05089 * width),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Match',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'AppliedSans',
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${match.toInt()}%',
                                style: const TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'Draft',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (index == 3) {
                        // Common Artists heading
                        return Container(
                          margin: EdgeInsets.only(
                              top: 0.02874 * height, left: 0.05089 * width),
                          child: const Text(
                            'Common Artists',
                            style: TextStyle(
                              fontSize: 30,
                              fontFamily: 'Draft',
                              color: Colors.white,
                            ),
                          ),
                        );
                      } else {
                        Map artistInfo = commonArtists[index - 4];
                        String artistName = artistInfo['name'];
                        String img = artistInfo['img'];
                        // The Artists List
                        return Material(
                          color: Colors.black,
                          child: InkWell(
                            child: ListTile(
                              minLeadingWidth: 0.127226 * width,
                              minVerticalPadding: 0.02395 * height,
                              onTap: () {},
                              leading: CircleAvatar(
                                foregroundImage: NetworkImage(img),
                              ),
                              title: AutoSizeText(
                                artistName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'AppliedSans',
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
