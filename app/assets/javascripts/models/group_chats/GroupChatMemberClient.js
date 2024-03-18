// @flow
import AxiosClient from '../AxiosClient';
import type { AxiosPromise } from 'axios';
import type { Member } from '../group_chats/Member';

type MessageReadStatuses = {
  seen_members: Array<Member>,
  unseen_members: Array<Member>,
};

export default class GroupChatMemberClient extends AxiosClient {
  fetchMembers(id: number): AxiosPromise<MessageReadStatuses> {
    return this.buildClient().get(`/api/v1/messages/${id}`);
  }
}
