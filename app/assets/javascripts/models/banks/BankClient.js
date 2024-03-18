// @flow
import AxiosClient from '../AxiosClient';
import type { AxiosPromise } from 'axios';
import type { Bank } from './Bank';
import type { BankBranch } from './BankBranch';

export default class BankClient extends AxiosClient {
  fetchAll(): AxiosPromise<Array<Bank>> {
    return this.buildClient().get('/api/v1/banks.json');
  }

  fetchBranches(bankId: number): AxiosPromise<Array<BankBranch>> {
    return this.buildClient().get('/api/v1/bank_branches.json', {
      params: {
        bank_id: bankId,
      },
    });
  }
}
