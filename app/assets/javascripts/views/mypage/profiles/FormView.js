// @flow
import JQueryView, { on } from '../../common/JQueryView';

declare var $: any;

export default class FormView extends JQueryView {
  image: any;

  constructor(image: string) {
    super('.simple_form');
    this.image = image;
    this.render();
  }

  @on('change #profile_image')
  onChangeImage(event: any) {
    if (event.target.files.length > 0) {
      const fr = new FileReader();

      fr.onload = () => {
        this.image = fr.result;
        this.render();
      };
      fr.readAsDataURL($(event.target).prop('files')[0]);
    }
  }

  render() {
    if (this.image !== '') {
      $('#preview')
        .css('background-image', `url(${this.image})`)
        .show();
    }
  }
}
