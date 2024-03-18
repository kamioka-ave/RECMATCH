// @flow
import AxiosClient from '../AxiosClient';
import type { AxiosPromise } from 'axios';
import type { UserAggregate } from './UserAggregate';

export default class UserClient extends AxiosClient {
  fetchUserAggregates(term: number): AxiosPromise<Array<UserAggregate>> {
    return this.buildClient().get('/recmatchadmin20180830/user_aggregates.json', {
      params: {
        term: term,
      },
    });
  }
}
