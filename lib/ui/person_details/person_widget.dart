import 'package:cine_reel/constants/api_constants.dart';
import 'package:cine_reel/models/tmdb_movie_details.dart';
import 'package:cine_reel/models/tmdb_person.dart';
import 'package:cine_reel/ui/common_widgets/blurred_image.dart';
import 'package:cine_reel/ui/common_widgets/common_widgets.dart';
import 'package:cine_reel/ui/common_widgets/loading_widget.dart';
import 'package:cine_reel/utils/helper_functions.dart';
import 'package:cine_reel/utils/image_helper.dart';
import 'package:cine_reel/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PersonWidget extends StatelessWidget {
  final TMDBPerson person;
  final Cast cast;
  final List<Widget> widgetsList = [];
  final bool showLoading;

  PersonWidget({Key key, this.person, this.cast, bool this.showLoading}) : super(key: key);
  final loadingWidget = LoadingWidget(
    visible: true,
  );

  @override
  Widget build(BuildContext context) {
    widgetsList.addAll([basicInfo(context), _populateBio()]);

    if (showLoading) {
      widgetsList.add(loadingWidget);
    } else {
      widgetsList.remove(loadingWidget);
    }

    return Scaffold(
      body: DefaultTextStyle(
        child: BlurredImage(
          imagePath: cast.profilePath,
          child: buildContent(),
        ),
        style: TextStyle(fontSize: 14.0),
      ),
    );
  }

  Widget buildContent() {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: [
              Container(
                  margin: const EdgeInsets.only(top: 45.0),
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(children: widgetsList)),
            ],
          ),
        ),
      ],
    );
  }

  Widget basicInfo(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        personName(),
        buildHorizontalDivider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            avatar(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  _buildIMDBLink(),
                  _populateBirthday(context),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget personName() {
    return Text(
      cast.name,
      style: STYLE_TITLE,
    );
  }

  Widget avatar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Hero(
        child: Material(
          color: Colors.transparent,
          child: _buildAvatar(),
        ),
        tag: "tag-${cast.id}",
      ),
    );
  }

  Widget _buildAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: Image(
        width: 180.0,
        image: image(
          cast.profilePath,
        ),
      ),
    );
  }

  Widget _buildIMDBLink() {
    return AnimateChildren(
        childOne: SizedBox.fromSize(
          size: Size.fromHeight(80.0),
          child: MaterialIcon("assets/imdb_icon.png", _launchIMDBUrl),
        ),
        childTwo: Container(),
        showHappyPath: person != null);
  }

  _launchIMDBUrl() {
    var url = "$IMDB_PERSON_PAGE_BASE_URL/${person.imdbId}";
    return launchURL(url);
  }

  Widget _populateBio() {
    return AnimateChildren(
        childOne: _biographyWidget(), childTwo: Container(), showHappyPath: person != null);
  }

  Widget _biographyWidget() {
    bool hasBiography = person?.hasBiography() ?? false;
    if (hasBiography) {
      return Column(
        children: <Widget>[
          Text(person.biography),
          buildHorizontalDivider(),
        ],
      );
    }
    return Container();
  }

  Widget _populateBirthday(BuildContext context) {
    return AnimateChildren(
        childOne: _birthdayWidget(), childTwo: Container(), showHappyPath: person != null);
  }

  Widget _birthdayWidget() {
    bool hasBirthdayDetails = person?.hasBirthdayDetails() ?? false;

    if (hasBirthdayDetails) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            buildHorizontalDivider(),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(person.getFormattedBirthday(),
                      style: TextStyle(
                        inherit: true,
                        fontSize: 16.0,
                      )),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Text(
                person.getPlaceOfBirth(),
                style: TextStyle(
                  inherit: true,
                  fontSize: 16.0,
                ),
              ),
            ),
            buildHorizontalDivider(),
          ],
        ),
      );
    }
    return Container();
  }
}