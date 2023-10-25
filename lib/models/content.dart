class Content {
  String? data;
  double? aspectRatio;
  String? description;

  Content({
    this.data,
    this.aspectRatio,
    this.description,
  });

  factory Content.fromJson(dynamic json, String? type) {
    if (json is Map<String, dynamic>) {
      switch (type) {
        case 'infobox':
          return Content(
            data: json['body'],
            aspectRatio: null,
            description: json['title'],
          );
      }
      if (json['mobile'] != null) {
        return Content(
          data: json['mobile']['url'],
          aspectRatio: json['mobile']['width'] / json['mobile']['height'],
          description: json['description'],
        );
      } else if (json['youtubeId'] != null) {
        return Content(
          data: json['youtubeId'],
          aspectRatio: null,
          description: json['description'],
        );
      } else if (json['filetype'] != null) {
        return Content(
          data: json['url'],
          aspectRatio: null,
          description: json['title'] + ';' + json['description'],
        );
      } else if (json['embeddedCode'] != null) {
        double? aspectRatio;

        if (json['width'] != null &&
            json['height'] != null &&
            json['width'] is String &&
            json['height'] is String) {
          aspectRatio =
              double.parse(json['width']) / double.parse(json['height']);
        }

        return Content(
          data: json['embeddedCode'],
          aspectRatio: aspectRatio,
          description: json['caption'],
        );
      } else if (json['draftRawObj'] != null) {
        return Content(
          data: json['body'],
          aspectRatio: null,
          description: json['title'],
        );
      } else if (json['quote'] != null) {
        return Content(
          data: json['quote'],
          aspectRatio: null,
          description: json['quoteBy'],
        );
      } else if (json['resized'] != null) {
        return Content(
            data: json['resized']['w800'],
            aspectRatio: 16 / 9,
            description: json['desc']);
      }

      return Content(data: null, aspectRatio: null, description: null);
    }

    return Content(
      data: json.toString(),
      aspectRatio: null,
      description: null,
    );
  }

  static List<Content> contentListFromJson(
      List<dynamic> jsonList, String? type) {
    List<Content> contentList = [];
    for (dynamic json in jsonList) {
      if (json != null && json != '') {
        contentList.add(Content.fromJson(json, type));
      }
    }

    return contentList;
  }
}
