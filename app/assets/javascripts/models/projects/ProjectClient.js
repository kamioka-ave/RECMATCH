// @flow
import * as axios from 'axios';
import jsonpAdapter from 'axios-jsonp';
import AxiosClient from '../AxiosClient';
import type { AxiosPromise } from 'axios';

export default class ProjectClient extends AxiosClient {
  fetchHistory(draftId: number, revision: number): AxiosPromise<any> {
    return this.buildClient().get(
      `/recmatchadmin20180830/projects/${draftId}/histories/${revision}.json`,
    );
  }

  fetchStagingProjects(): AxiosPromise<any> {
    const client = axios.create({
      baseURL: 'https://stg6dw.recmatch.com',
      adapter: jsonpAdapter,
      cache: false,
    });
    return client.get('/api/v1/projects.json?jsonp');
  }
}
