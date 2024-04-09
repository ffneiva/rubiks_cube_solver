import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rubiks_cube_solver/src/utils/functions.dart';
import 'package:rubiks_cube_solver/src/widgets/rubik_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutView extends StatefulWidget {
  const AboutView({
    Key? key,
  }) : super(key: key);

  static const routeName = '/about';

  @override
  State<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends State<AboutView> {
  @override
  Widget build(BuildContext context) {
    AppLocalizations locale = AppLocalizations.of(context)!;

    Map<String, String> data = {
      locale.aboutExtensionProject: locale.aboutExtensionProjectParagraphs,
      locale.aboutKociembaAlgorithm: locale.aboutKociembaAlgorithmParagraphs,
      locale.aboutGodNumber: locale.aboutGodNumberParagraphs,
    };

    List<Widget> topics = [];
    data.forEach(
        (title, paragraph) => topics.add(_aboutTopic(title, paragraph)));

    return RubikScaffold(
      title: locale.aboutPage,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/robot.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                  color: Theme.of(context).canvasColor.withOpacity(0.6)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(child: Column(children: topics)),
                ),
                GestureDetector(
                  child: Center(
                    child: Text(
                      getCopyright(),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  onTap: () => launchUrl(Uri.parse(getCopyrightLink())),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutTopic(String title, String paragraph) {
    return Column(children: [
      Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      Text(
        paragraph,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.justify,
      ),
      const SizedBox(height: 24),
    ]);
  }
}
