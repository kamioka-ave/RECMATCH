// @flow
import AxiosClient from '../AxiosClient';
import type { AxiosPromise } from 'axios';
import type { Message } from './Message';
import App from '../App';

export default class GroupChatClient extends AxiosClient {
  buffer: Array<Message> = [];
  groupChatChannel: any;
  groupChatId: number;
  _received: (message: any) => void;

  constructor(groupChatId: number) {
    super();
    this.groupChatId = groupChatId;
    this.groupChatChannel = this._buildChannel();
  }

  set received(callback: (message: any) => void) {
    this._received = callback;
  }

  getBufferedMessages(): Array<any> {
    return this.buffer.map((message: Message) => ({
      body: message.body,
      createdAt: '送信中',
      loading: true,
      attachmentName: message.attachment ? 'アップロード中' : null,
      attachmentUrl: '#',
    }));
  }

  sendMessage(message: Message): void {
    this._appendMetaData(message);
    this.buffer.push(message);
    message.attachment ? this._sendHttp(message) : this._sendWebSocket(message);
  }

  fetchMessages(page: number): AxiosPromise<Object> {
    return this.buildClient().get(
      `/api/v1/group_chats/${this.groupChatId}/messages`,
      {
        params: { page: page },
      },
    );
  }

  markAllAsRead(memberId: number, memberType: string): AxiosPromise<Object> {
    return this.buildClient().put(
      `/api/v1/group_chats/${this.groupChatId}/mark_all_as_read`,
      {
        member_id: memberId,
        member_type: memberType,
      },
    );
  }

  _sendHttp(message: Message): AxiosPromise<Object> {
    const data = new FormData();
    data.append('message[body]', message.body);
    data.append('message[sender_id]', message.senderId.toString());
    data.append('message[sender_type]', message.senderType);
    if (message.metaData)
      data.append('message[meta_data]', JSON.stringify(message.metaData));
    if (message.attachment)
      data.append('message[attachment]', message.attachment);
    return this.buildClient()
      .post(`/api/v1/group_chats/${message.groupChatId}/send_message`, data)
      .catch(err => console.log(err));
  }

  _sendWebSocket(message: Message) {
    this.groupChatChannel.sendMessage(message);
  }

  _buildChannel = () =>
    App.cable.subscriptions.create(
      {
        channel: 'GroupChatChannel',
        group_id: this.groupChatId,
      },
      {
        received: (data: any) => {
          if (data.message.metaData) {
            this.buffer = this.buffer.filter((e: Message) => {
              !e.metaData ||
                e.metaData.msgIdentifier != data.message.metaData.msgIdentifier;
            });
          }
          this._received(data.message);
        },
        sendMessage: (message: Message) => {
          this.groupChatChannel.perform('send_message', message);
        },
      },
    );

  _appendMetaData(message: Message) {
    message.metaData = {
      msgIdentifier: `${message.senderId}${message.senderType}${Date.now()}`,
      sentAt: Date.now(),
    };
  }
}
