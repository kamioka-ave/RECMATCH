// @flow
import AxiosClient from '../models/AxiosClient';
import type { AxiosPromise } from 'axios';

export default class PushNotificationClient extends AxiosClient {
  createUserToken(token: string): AxiosPromise<any> {
    return this.buildClient().post('/api/v1/user_tokens', {
      user_token: { device_token: token },
    });
  }
}
