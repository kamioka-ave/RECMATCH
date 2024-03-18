// @flow
import * as axios from 'axios';

export default class AxiosClient {
  buildClient(config: Object = {}): any {
    return axios.create({
      ...config,
      timeout: 30000,
    });
  }
}
