import React, { NativeModules, NativeEventEmitter } from 'react-native';

const NativeNotificationManager = NativeModules.NotificationManager;

let NativeNotification;
export default NativeNotification = {
  postNotification : function(name, userInfo) {
    NativeNotificationManager.postNotification(name, userInfo);
  }
}