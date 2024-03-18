// @flow
import moment from 'moment';

export function date(date: ?string): string {
  return date != null ? moment(date).format('YYYY年MM月DD日') : '';
}

export function datetime(datetime: ?string): string {
  return datetime != null
    ? moment(datetime).format('YYYY年MM月DD日 HH:SS')
    : '';
}

export function delimited(n: ?number): string {
  if (n == null) {
    return '';
  }

  return String(n).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, '$1,');
}

export function filename(path: ?string): string {
  if (path == null) {
    return '';
  }

  const arr = path.match('.+/(.+?)([#;].*)?$');
  if (arr == null) {
    return '';
  }

  return arr[1];
}
