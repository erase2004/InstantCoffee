import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:localstorage/localstorage.dart';
import 'package:readr_app/models/notificationSetting.dart';
import 'package:readr_app/models/notificationSettingList.dart';

class FirebaseMessangingHelper {
  FirebaseMessaging _firebaseMessaging;

  FirebaseMessangingHelper() {
    _firebaseMessaging = FirebaseMessaging();
  }

  configFirebaseMessaging() {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }
  
  // not use
  subscribeAllOfSubscribtionTopic() async{
    LocalStorage storage = LocalStorage('setting');
    NotificationSettingList notificationSettingList = NotificationSettingList();
    
    if (await storage.ready) {
      notificationSettingList =
          NotificationSettingList.fromJson(storage.getItem("notification"));
    }

    if (notificationSettingList == null) {
      notificationSettingList = await _getNotification(storage);
    }

    notificationSettingList.forEach(
      (notificationSetting) {
        if(notificationSetting.id == 'horoscopes' || notificationSetting.id == 'subscriptionChannels') {
          if(notificationSetting.value) {
            notificationSetting.notificationSettingList.forEach(
              (element) { 
                if(element.value) {
                  subscribeToTopic(element.topic);
                }
              }
            );
          }
        }
        else {
          if(notificationSetting.value) {
            subscribeToTopic(notificationSetting.topic);
          }
        }
      }
    );
  }

  // not use
  Future<NotificationSettingList> _getNotification(LocalStorage storage) async {
    var jsonSetting =
        await rootBundle.loadString('assets/data/defaultNotificationList.json');
    var jsonSettingList = json.decode(jsonSetting)['defaultNotificationList'];

    NotificationSettingList notificationSettingList =
        NotificationSettingList.fromJson(jsonSettingList);
    storage.setItem("notification", jsonSettingList);

    return notificationSettingList;
  }
  
  subscribeTheNotification(NotificationSetting notificationSetting) {
    if(notificationSetting.id == 'horoscopes' || notificationSetting.id == 'subscriptionChannels') {
      notificationSetting.notificationSettingList.forEach(
        (element) { 
          if(notificationSetting.value && element.value) {
            subscribeToTopic(element.topic);
          }
          else if(!notificationSetting.value && element.value){
            unsubscribeFromTopic(element.topic);
          }
        }
      );
    }
    else {
      if(notificationSetting.value) {
        subscribeToTopic(notificationSetting.topic);
      }
      else {
        unsubscribeFromTopic(notificationSetting.topic);
      }
    }
  }

  subscribeToTopic(String topic) {
    _firebaseMessaging.subscribeToTopic(topic);
  }

  unsubscribeFromTopic(String topic) {
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  dispose() {}
}