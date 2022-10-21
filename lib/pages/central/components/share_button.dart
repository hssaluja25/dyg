import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({required this.url, required this.fallbackUrl, super.key});
  final String url;
  final String fallbackUrl;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final Uri spotifyShareLink = Uri.parse(url);
        final Uri fallbackUri = Uri.parse(fallbackUrl);
        () async {
          if (await canLaunchUrl(spotifyShareLink)) {
            launchUrl(spotifyShareLink);
          } else if (await canLaunchUrl(fallbackUri)) {
            launchUrl(fallbackUri);
          } else {
            ScaffoldMessenger.of(context)
              ..removeCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  content: Text(
                      "Your device doesn't support opening this type of link"),
                ),
              );
          }
        }();
      },
      icon: const FaIcon(
        FontAwesomeIcons.share,
        color: Colors.white,
      ),
    );
  }
}
