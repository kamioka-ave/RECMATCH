// @flow
import AxiosClient from '../AxiosClient';
import type { AxiosPromise } from 'axios';

export default class SummernoteClient extends AxiosClient {
  create(file: File): AxiosPromise<any> {
    const data = new FormData();
    data.append('summernote[image]', file);
    return this.buildClient().post('/api/v1/summernotes', data);
  }

  createMy(file: File): AxiosPromise<any> {
    const data = new FormData();
    data.append('summernote[image]', file);
    return this.buildClient().post('/mypage/summernotes', data);
  }
}
