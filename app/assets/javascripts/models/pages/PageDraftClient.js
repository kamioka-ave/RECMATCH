// @flow
import AxiosClient from '../AxiosClient';
import type { AxiosPromise } from 'axios';

export default class PageDraftClient extends AxiosClient {
  fetchHistory(id: number, revision: number): AxiosPromise<any> {
    return this.buildClient().get(`/recmatchadmin20180830/pages/${id}.json`, {
      params: {
        version: revision,
      },
    });
  }
}
