import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Results extends StatefulWidget {
  const Results({super.key, required this.value});
  final double value;

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
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
              // Diamond
              Positioned(
                top: 0.11976 * height,
                left: (width / 2) - 50,
                child: Image.asset(
                  'assets/images/results/diamond.png',
                  color: Colors.white,
                  height: 100,
                  width: 100,
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
                top: height / 3,
                child: SizedBox(
                  height: 2 * height / 3,
                  width: width,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    addAutomaticKeepAlives: true,
                    cacheExtent: 100,
                    itemCount: 33,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        // Comparing with <Name> heading
                        return Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 0.05089 * width),
                          child: const AutoSizeText(
                            'Comparing with Edward',
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'District',
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
                                      value: widget.value,
                                      color: const Color.fromARGB(
                                          255, 15, 232, 211),
                                      backgroundColor:
                                          Colors.white.withOpacity(0.80),
                                      strokeWidth: 10,
                                    ),
                                  ),
                                ),
                              ),
                              // Value% in the center of the graph
                              Text(
                                '${(widget.value * 100).toInt()}%',
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
                        // Music Taste Match: value%
                        return Container(
                          margin: EdgeInsets.only(
                            left: 0.07633 * width,
                            right: 0.07633 * width,
                            top: 0.021557 * height,
                          ),
                          child: AutoSizeText(
                            'Artists Match: ${(widget.value * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 30,
                              fontFamily: 'District',
                              color: Colors.white,
                            ),
                            maxLines: 1,
                          ),
                        );
                      } else if (index == 3) {
                        // Common Artists
                        return Container(
                          margin: EdgeInsets.only(
                              top: 0.02874 * height, left: 0.05089 * width),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Common part of Common Artists heading
                              const Text(
                                'Common',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'District',
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    height: 0.002395 * height,
                                    width: 0.254453 * width,
                                  ),
                                  const Text(
                                    'Artists',
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontFamily: 'District',
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      } else {
                        // The Artists List
                        return Material(
                          color: Colors.black,
                          child: InkWell(
                            child: ListTile(
                              minLeadingWidth: 0.127226 * width,
                              minVerticalPadding: 0.02395 * height,
                              onTap: () {},
                              leading: const CircleAvatar(
                                foregroundImage: AssetImage(
                                    'assets/images/results/avatar.jpg'),
                              ),
                              title: AutoSizeText(
                                'Artist Name ${index - 3}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Roboto',
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
