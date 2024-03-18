// @flow
import AxiosClient from '../AxiosClient';
import type { AxiosPromise } from 'axios';
import type { FileStorageResponse } from './FileStorageResponse';

export default class FileStorageClient extends AxiosClient {
  groupChatId: number;

  constructor(groupChatId: number) {
    super();
    this.groupChatId = groupChatId;
  }

  fetchAttachments(page: number): AxiosPromise<FileStorageResponse> {
    return this.buildClient().get(
      `/api/v1/group_chats/${this.groupChatId}/attachments`,
      { params: { page: page } },
    );
  }
}
