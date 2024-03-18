export default class StringUtil {
  static convertHalfToFull(str) {
    return str.replace(/[A-Za-z]/g, s =>
      String.fromCharCode(s.charCodeAt(0) + 0xfee0),
    );
  }

  static convertJaSmallToLarge(str) {
    const map = {
      ぁ: 'あ',
      ぃ: 'い',
      ぅ: 'う',
      ぇ: 'え',
      ぉ: 'お',
      っ: 'つ',
      ゃ: 'や',
      ゅ: 'ゆ',
      ょ: 'よ',
      ゎ: 'わ',
      ァ: 'ア',
      ィ: 'イ',
      ゥ: 'ウ',
      ェ: 'エ',
      ォ: 'オ',
      ヵ: 'カ',
      ヶ: 'ケ',
      ッ: 'ツ',
      ャ: 'ヤ',
      ュ: 'ユ',
      ョ: 'ヨ',
      ヮ: 'ワ',
    };

    return str.replace(
      /[\u3041-\u3096\u30A1-\u30FA]/g,
      s => (s in map ? map[s] : s),
    );
  }
}
