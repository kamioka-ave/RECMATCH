// @flow
import { config } from './firebaseConfig';
import firebase from 'firebase/app';
import { initializePush } from './initialize';

firebase.initializeApp(config);
initializePush();
