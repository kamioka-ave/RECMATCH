import GeoClient from "models/heartrails/GeoClient";

describe('GeoClient', () => {
  const client = new GeoClient();

  describe('convert', () => {
    describe('レスポンスが渡された場合', () => {
      const r = client.convert([
        {
          city: '品川区',
          city_kana: 'しながわく',
          town: '東五反田一丁目',
          town_kana: 'ひがしごたんだ',
          x: '139.726034',
          y: '35.626324',
          prefecture: '東京都',
          postal: '1410022',
        },
        {
          city: '品川区',
          city_kana: 'しながわく',
          town: '東五反田二丁目',
          town_kana: 'ひがしごたんだ',
          x: '139.72818',
          y: '35.623908',
          prefecture: '東京都',
          postal: '1410022',
        },
      ]);

      it('正常な住所を返すこと', () => {
        expect(r.length).toBe(3);
        expect(r[0].town).toBe('東五反田一丁目');
        expect(r[1].town).toBe('東五反田二丁目');
        expect(r[2].town).toBe('');
        expect(r[0].address).toBe('東京都品川区東五反田一丁目');
        expect(r[1].address).toBe('東京都品川区東五反田二丁目');
        expect(r[2].address).toBe('東京都品川区');
      });
    });

    describe('レスポンスが渡された場合', () => {
      const r = client.convert([
        {
          city: '品川区',
          city_kana: 'しながわく',
          town: '東五反田一丁目（3番地〜5番地まで）',
          town_kana: 'ひがしごたんだ',
          x: '139.726034',
          y: '35.626324',
          prefecture: '東京都',
          postal: '1410022',
        },
        {
          city: '品川区',
          city_kana: 'しながわく',
          town: '東五反田二丁目）',
          town_kana: 'ひがしごたんだ',
          x: '139.72818',
          y: '35.623908',
          prefecture: '東京都',
          postal: '1410022',
        },
      ]);

      it('正常な住所を返すこと', () => {
        expect(r.length).toBe(2);
        expect(r[0].town).toBe('東五反田一丁目');
        expect(r[1].town).toBe('');
        expect(r[0].address).toBe('東京都品川区東五反田一丁目');
        expect(r[1].address).toBe('東京都品川区');
      });
    });

    describe('レスポンスが渡された場合', () => {
      const r = client.convert([
        {
          city: '品川区',
          city_kana: 'しながわく',
          town: '境町の次に番地がくる場合',
          town_kana: 'ひがしごたんだ',
          x: '139.726034',
          y: '35.626324',
          prefecture: '東京都',
          postal: '1410022',
        },
        {
          city: '品川区',
          city_kana: 'しながわく',
          town: '東五反田二丁目',
          town_kana: 'ひがしごたんだ',
          x: '139.72818',
          y: '35.623908',
          prefecture: '東京都',
          postal: '1410022',
        }
      ]);

      it('正常な住所を返すこと', () => {
        expect(r.length).toBe(2);
        expect(r[0].town).toBe('東五反田二丁目');
        expect(r[1].town).toBe('');
        expect(r[0].address).toBe('東京都品川区東五反田二丁目');
        expect(r[1].address).toBe('東京都品川区');
      });
    });

    describe('レスポンスが渡された場合', () => {
      const r = client.convert([
        {
          city: '品川区',
          city_kana: 'しながわく',
          town: '東五反田一丁目',
          town_kana: 'ひがしごたんだ',
          x: '139.726034',
          y: '35.626324',
          prefecture: '東京都',
          postal: '1410022',
        },
        {
          city: '品川区',
          city_kana: 'しながわく',
          town: '東五反田二丁目',
          town_kana: 'ひがしごたんだ',
          x: '139.72818',
          y: '35.623908',
          prefecture: '東京都',
          postal: '1410022',
        },
        {
          city: '新宿区',
          city_kana: 'しんじゅくく',
          town: '歌舞伎町',
          town_kana: 'かぶきちょう',
          x: '139.72228',
          y: '35.623922',
          prefecture: '東京都',
          postal: '1410022',
        },
      ]);

      it('正常な住所を返すこと', () => {
        expect(r.length).toBe(5);
        expect(r[0].town).toBe('東五反田一丁目');
        expect(r[1].town).toBe('東五反田二丁目');
        expect(r[2].town).toBe('歌舞伎町');
        expect(r[0].address).toBe('東京都品川区東五反田一丁目');
        expect(r[1].address).toBe('東京都品川区東五反田二丁目');
        expect(r[2].address).toBe('東京都新宿区歌舞伎町');
        expect(r[3].address).toBe('東京都品川区');
        expect(r[4].address).toBe('東京都新宿区');
      });
    });

    describe('レスポンスが渡された場合', () => {
      const r = client.convert([
        {
          city: '弥富市',
          city_kana: 'やとみし',
          town: '曙１丁目',
          town_kana: 'あけぼの1ちょうめ',
          x: '136.755854',
          y: '35.046471',
          prefecture: '愛知県',
          postal: '4980000',
        },
        {
          city: '弥富市',
          city_kana: 'やとみし',
          town: '曙２丁目',
          town_kana: 'あけぼの2ちょうめ',
          x: '136.767299',
          y: '35.031553',
          prefecture: '愛知県',
          postal: '4980000',
        },
        {
          city: '弥富市',
          city_kana: 'やとみし',
          town: '栄南町',
          town_kana: 'えいなんちょう',
          x: '136.749008',
          y: '35.074441',
          prefecture: '愛知県',
          postal: '4980000',
        },
        {
          city: '弥富市',
          city_kana: 'やとみし',
          town: '大縄場町',
          town_kana: 'おおなわばちょう',
          x: '136.7566',
          y: '35.079338',
          prefecture: '愛知県',
          postal: '4980000',
        },
        {
          city: '弥富市',
          city_kana: 'やとみし',
          town: '大藤町',
          town_kana: 'おおふじちょう',
          x: '136.735187',
          y: '35.093466',
          prefecture: '愛知県',
          postal: '4980000',
        },
        {
          city: '弥富市',
          city_kana: 'やとみし',
          town: '亀ケ地新田',
          town_kana: 'かめがんじしんでん',
          x: '136.783663',
          y: '35.106011',
          prefecture: '愛知県',
          postal: '4980000',
        },
        {
          city: '桑名郡木曽岬町',
          city_kana: 'くわなぐんきそさきちょう',
          town: '（その他）',
          town_kana: '(そのた)',
          x: '136.742309',
          y: '35.064676',
          prefecture: '三重県',
          postal: '4980000',
        },
        {
          city: '弥富市',
          city_kana: 'やとみし',
          town: '（その他）',
          town_kana: '(そのた)',
          x: '136.75498',
          y: '35.087056',
          prefecture: '愛知県',
          postal: '4980000',
        },
      ]);

      it('正常な住所を返すこと', () => {
        expect(r.length).toBe(8);
        expect(r[0].address).toBe('愛知県弥富市曙１丁目');
        expect(r[1].address).toBe('愛知県弥富市曙２丁目');
        expect(r[2].address).toBe('愛知県弥富市栄南町');
        expect(r[3].address).toBe('愛知県弥富市大縄場町');
        expect(r[4].address).toBe('愛知県弥富市大藤町');
        expect(r[5].address).toBe('愛知県弥富市亀ケ地新田');
        expect(r[6].address).toBe('愛知県弥富市');
        expect(r[7].address).toBe('三重県桑名郡木曽岬町');
      });
    });

    describe('レスポンスが渡された場合', () => {
      const r = client.convert([
        {
          city: '田方郡函南町',
          city_kana: 'たがたぐんかんなみちょう',
          town: '桑原（茨ヶ平）',
          town_kana: 'くわはら(いばらがひら)',
          x: '138.975286',
          y: '35.1138094',
          prefecture: '静岡県',
          postal: '4110001',
        },
        {
          city: '田方郡函南町',
          city_kana: 'たがたぐんかんなみちょう',
          town: '桑原（箱根峠）',
          town_kana: 'くわはら(はこねとうげ)',
          x: '138.975286',
          y: '35.1138094',
          prefecture: '静岡県',
          postal: '4110001',
        },
      ]);

      it('正常な住所を返すこと', () => {
        expect(r.length).toBe(2);
        expect(r[0].town).toBe('桑原');
        expect(r[1].town).toBe('');
        expect(r[0].address).toBe('静岡県田方郡函南町桑原');
        expect(r[1].address).toBe('静岡県田方郡函南町');
      });
    });
  });
});
