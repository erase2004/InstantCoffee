import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:readr_app/helpers/environment.dart';
import 'package:readr_app/models/record.dart';
import 'jsonAndObject.dart';

void main() {
  Environment().initConfig(BuildFlavor.development);
  final List<JsonAndObject<Record>> jsonAndObjectList = [
    JsonAndObject<Record>(
      responseBody: 
          '''
          {
            "title": "title",
            "slug": "slug",
            "publishTime": "19110101",
            "photoUrl": "dummy_url",
            "categories": null,
            "sections": null
          }
          ''',
      object: Record(
        title: "title",
        slug: "slug",
        publishedDate: "19110101",
        photoUrl: "dummy_url",
        isMemberCheck: false,
        isMemberContent: false,
      ),
    ),
    JsonAndObject<Record>(
      responseBody: 
          '''
          {
            "snippet": {
              "title": "title"
            },
            "slug": "slug",
            "publishTime": "19110101",
            "photoUrl": "dummy_url",
            "categories": null,
            "sections": null
          }
          ''',
      object: Record(
        title: "title",
        slug: "slug",
        publishedDate: "19110101",
        photoUrl: "dummy_url",
        isMemberCheck: false,
        isMemberContent: false,
      ),
    ),
    JsonAndObject<Record>(
      responseBody: 
          '''
          {
            "title": "title",
            "id": {
              "videoId": "videoId"
            },
            "publishTime": "19110101",
            "photoUrl": "dummy_url",
            "categories": null,
            "sections": null
          }
          ''',
      object: Record(
        title: "title",
        slug: "videoId",
        publishedDate: "19110101",
        photoUrl: "dummy_url",
        isMemberCheck: false,
        isMemberContent: false,
      ),
    ),
     JsonAndObject<Record>(
      responseBody: 
          '''
          {
            "title": "title",
            "slug": "slug",
            "publishedDate": "19110101",
            "photoUrl": "dummy_url",
            "categories": null,
            "sections": null
          }
          ''',
      object: Record(
        title: "title",
        slug: "slug",
        publishedDate: "19110101",
        photoUrl: "dummy_url",
        isMemberCheck: false,
        isMemberContent: false,
      ),
    ),
    JsonAndObject<Record>(
      responseBody: 
          '''
          {
            "title": "title",
            "slug": "slug",
            "publishTime": "19110101",
            "heroImage": {
              "image": {
                "resizedTargets": {
                  "mobile": {
                    "url": "dummy_url"
                  }
                }
              }
            },
            "categories": null,
            "sections": null
          }
          ''',
      object: Record(
        title: "title",
        slug: "slug",
        publishedDate: "19110101",
        photoUrl: "dummy_url",
        isMemberCheck: false,
        isMemberContent: false,
      ),
    ),
    JsonAndObject<Record>(
      responseBody: 
          '''
          {
            "slug": "slug",
            "publishTime": "19110101",
            "snippet": {
              "title": "title",
              "thumbnails": {
                "medium": {
                  "url": "dummy_url"
                }
              }
            },
            "categories": null,
            "sections": null
          }
          ''',
      object: Record(
        title: "title",
        slug: "slug",
        publishedDate: "19110101",
        photoUrl: "dummy_url",
        isMemberCheck: false,
        isMemberContent: false,
      ),
    ),
    JsonAndObject<Record>(
      responseBody: 
          '''
          {
            "title": "title",
            "slug": "slug",
            "publishTime": "19110101",
            "photoUrl": "dummy_url",
            "categories": [
              {
                "_id": "id",
                "name": "name",
                "title": "title",
                "isMemberOnly": true
              }
            ],
            "sections": null
          }
          ''',
      object: Record(
        title: "title",
        slug: "slug",
        publishedDate: "19110101",
        photoUrl: "dummy_url",
        isMemberCheck: true,
        isMemberContent: false,
      ),
    ),
    JsonAndObject<Record>(
      responseBody: 
          '''
          {
            "title": "title",
            "slug": "slug",
            "publishTime": "19110101",
            "photoUrl": "dummy_url",
            "categories": null,
            "sections": [
              {
                "name": "member"
              }
            ]
          }
          ''',
      object: Record(
        title: "title",
        slug: "slug",
        publishedDate: "19110101",
        photoUrl: "dummy_url",
        isMemberCheck: false,
        isMemberContent: true,
      ),
    ),
  ];

  group('Record model:', () {
    for(int i=0; i<jsonAndObjectList.length; i++) {
      test('fromJson function (JsonAndObject[$i])', () {
        JsonAndObject<Record> jsonAndObject = jsonAndObjectList[i];
        final body = jsonAndObject.responseBody;
        final json = jsonDecode(body);
        Record record = Record.fromJson(json);
        expect(
          record, 
          jsonAndObject.object
        );
      });
    }

    test('recordListFromJson function', () async {
      List<dynamic> jsonList = [];
      List<Record> expectedList = [];
      jsonAndObjectList.forEach(
        (jsonAndObject) { 
          final json = jsonDecode(jsonAndObject.responseBody);
          jsonList.add(json);
          expectedList.add(jsonAndObject.object);
        }
      );

      List<Record> recordList = Record.recordListFromJson(jsonList);
      expect(
        recordList,
        expectedList
      );
    });

    test('filterDuplicatedSlugByAnother function', () async {
      List<Record> baseList = [
        Record(
          title: "title1",
          slug: "slug1",
          publishedDate: "19110101",
          photoUrl: "dummy_url",
          isMemberCheck: false,
          isMemberContent: true,
        ),
        Record(
          title: "title2",
          slug: "slug2",
          publishedDate: "19110101",
          photoUrl: "dummy_url",
          isMemberCheck: false,
          isMemberContent: true,
        ),
      ];
      List<Record> anotherList = [
        Record(
          title: "title1",
          slug: "slug1",
          publishedDate: "19110101",
          photoUrl: "dummy_url",
          isMemberCheck: false,
          isMemberContent: true,
        ),
      ];
      List<Record> expectedList = [
        Record(
          title: "title2",
          slug: "slug2",
          publishedDate: "19110101",
          photoUrl: "dummy_url",
          isMemberCheck: false,
          isMemberContent: true,
        ),
      ];
      List<Record> recordList = Record.filterDuplicatedSlugByAnother(baseList, anotherList);
      
      expect(
        recordList,
        expectedList
      );
    });
  });
}