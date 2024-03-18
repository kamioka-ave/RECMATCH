// @flow
import AxiosClient from '../AxiosClient';
import type { AxiosPromise } from 'axios';

export default class IdentificationClient extends AxiosClient {
  fetchHistory(identificationId: number, id: number): AxiosPromise<any> {
    return this.buildClient().get(
      `/recmatchadmin20180830/identifications/${identificationId}/histories/${id}.json`,
    );
  }

  removeHistoryImage(
    identificationId: number,
    id: number,
    name: string,
  ): AxiosPromise<any> {
    const params = { identification_history: {} };
    params['identification_history'][`remove_${name}`] = true;
    return this.buildClient().patch(
      `/recmatchadmin20180830/identifications/${identificationId}/histories/${id}.json`,
      params,
    );
  }

  createHistoryImage(
    identificationId: number,
    id: number,
    name: string,
    file: File,
  ): AxiosPromise<any> {
    const data = new FormData();
    data.append(`identification_history[${name}]`, file);
    return this.buildClient().patch(
      `/recmatchadmin20180830/identifications/${identificationId}/histories/${id}.json`,
      data,
    );
  }
}
