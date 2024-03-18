// @flow
import AxiosClient from '../AxiosClient';
import type { AxiosPromise } from 'axios';
import type { CompanyAggregate } from './CompanyAggregate';

export default class CompanyClient extends AxiosClient {
  fetchCompanyAggregates(term: number): AxiosPromise<Array<CompanyAggregate>> {
    return this.buildClient().get('/recmatchadmin20180830/company_aggregates.json', {
      params: {
        term: term,
      },
    });
  }
}
