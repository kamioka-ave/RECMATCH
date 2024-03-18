// @flow
import firebase from 'firebase/app';
import 'firebase/messaging';
import PushNotificationClient from './PushNotificationClient';

export function initializePush() {
  const messaging = firebase.messaging();
  messaging
    .requestPermission()
    .then(() => {
      return messaging.getToken();
    })
    .then(token => {
      new PushNotificationClient().createUserToken(token);
    })
    .catch(error => {
      if (error.code === 'messaging/permission-blocked') {
        console.log('Please Unblock Notification Request Manually');
      } else {
        console.log('Error Occurred', error);
      }
    });
  messaging.onMessage(payload => {
    console.log('Notification Received', payload);
  });
}
