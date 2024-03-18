// @flow
import moment from 'moment';

export type ChartDataPoint = {
  t?: Date | moment,
  y?: number,
  x?: number,
  time?: Date,
  value?: number,
};
