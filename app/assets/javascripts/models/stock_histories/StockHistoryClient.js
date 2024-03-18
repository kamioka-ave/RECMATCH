// @flow
import AxiosClient from '../AxiosClient';
import type { AxiosPromise } from 'axios';
import type { ChartDataPoint } from './ChartDataPoint';

export default class StockHistoryClient extends AxiosClient {
  fetchStockHistory(companyId?: number): AxiosPromise<Array<ChartDataPoint>> {
    return this.buildClient().get('/api/v1/stock_histories', {
      params: {
        company_id: companyId,
      },
    });
  }
}
