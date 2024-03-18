// @flow
import AxiosClient from '../AxiosClient';
import App from '../App';

export default class NotificationClient extends AxiosClient {
  userId: number;
  notificationChannel: any;
  _received: (message: any) => void;

  constructor(userId: number) {
    super();
    this.userId = userId;
    this.notificationChannel = this._buildChannel();
  }

  set received(callback: (message: any) => void) {
    this._received = callback;
  }

  fetchNotification(page: number): AxiosPromise<any> {
    return this.buildClient().get(
      `/api/v1/members/${this.userId}/notifications`,
      { params: { page: page } },
    );
  }

  checkHaveNotificationUnread(): AxiosPromise<any> {
    return this.buildClient().get(
      `/api/v1/members/${this.userId}/unread_messages`,
    );
  }

  _buildChannel = () =>
    App.cable.subscriptions.create(
      {
        channel: 'NotificationChannel',
        user_id: this.userId,
      },
      {
        received: (data: any) => {
          this._received(data);
        },
      },
    );
}
