// @flow
import axios from 'axios';
import jsonpAdapter from 'axios-jsonp';
import _ from 'lodash';

//const BASE_URL = 'https://geoapi.heartrails.com';
const BASE_URL = 'https://cloud-capital.heartrails-geoapi.com';

export default class GeoClient {
  fetchByZipCode(zipcode: string): Promise<any> {
    return this.buildClient().get('/api/json?jsonp', {
      params: {
        method: 'searchByPostal',
        postal: zipcode,
      },
    });
  }

  // private methods

  buildClient(): any {
    const client = axios.create({
      baseURL: BASE_URL,
      adapter: jsonpAdapter,
      cache: false,
      timeout: 10000,
    });

    client.interceptors.response.use(response => {
      if (
        response.data &&
        response.data.response &&
        response.data.response.location
      ) {
        return this.convert(response.data.response.location);
      } else {
        return response;
      }
    });

    return client;
  }

  /**
   * 取得した住所レコードを修正する
   *  整形ルール
   *     obj.town の値の中に'（'があったらそれ以降は削除する。'（'の前の町名のみが残る。 => ①
   *     obj.town の値の中に'（'がなくて '）'があるレコードには町名が入っていないので(1郵便番号のレコードが2件になっている場合)、そのレコードを配列から取り除く。=> ②
   *     obj.town の値の中が "○○市（または町・村）の次に番地がくる場合"の場合、「○○市（または町・村）」は、obj.city に入っているので、town の値を消す。=> ③
   *     obj.prefecture + obj.city だけの住所を一覧に加える(選択肢に期待する住所がない場合に対応するため)。=> ④
   *     〒411-0001 2件のレコードがある。obj.town が「桑原（茨ヶ平）」と「桑原（箱根峠）」であるため重複データができてしまう。
   *               しかもこの2件は緯度経度が同じである。順番が先の住所を表示に使う。 => ⑤
   *
   * @param サーバからの値(res.data.response.location)
   */
  convert(addresses: any): any {
    const regexp = [/（.+$/, /.*以下に掲載がない場合.*$/];

    /* ④の時のkey(それ以外は緯度＋経度) */
    let defaultNum = Math.random() * 100000;

    /* prefecture + cityでユニークを取って、Objectの配列を返す→④を作成する */
    const anotherSelects = _.uniqBy(
      addresses,
      add => add.prefecture + add.city,
    ).map(add => {
      defaultNum += 1;
      return {
        address: add.prefecture + add.city,
        prefecture: add.prefecture,
        town: '',
        city: add.city,
        key: defaultNum.toString(),
      };
    });

    /* この関数のMain */
    const result = _.chain(addresses)
      .map(add => {
        /* キーは緯度＋経度の文字列 */
        return {
          prefecture: add.prefecture,
          city: add.city,
          town: add.town,
          postal: add.postal,
          key: add.x + add.y,
          address: add.prefecture + add.city + add.town,
        };
      })
      .map(value => {
        _.each(regexp, r => {
          const changed = _.replace(value.town, r, '');
          if (changed !== value.town) {
            value.town = changed;
            value.address = value.prefecture + value.city + value.town;
          }
        });
        return value;
      })
      .filter(value => {
        /* 後でconcatする住所と同じものは取り除く */
        let available = true;
        _.each(anotherSelects, s => {
          if (s.address === value.address) {
            available = false;
          }
        });
        /* ②と③ */
        const flag =
          !/^.*）.*$/.test(value.town) &&
          !/次に番地がくる場合/.test(value.town) &&
          available;
        return flag;
      })
      .concat(anotherSelects) // ④
      .uniqBy(add => add.address) // ⑤
      .value();
    return result;
  }
}
