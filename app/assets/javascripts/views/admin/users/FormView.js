// @flow
import JQueryView, { on } from '../../common/JQueryView';

export default class FormView extends JQueryView {
  image: any;

  constructor(image: string) {
    super('.simple_form');
    this.image = image;
    this.render();
  }

  @on('change #user_profile_attributes_image')
  onChangeImage(event: any) {
    if (!event.target.files.length) {
      return;
    }

    const file = $(event.target).prop('files')[0];
    const fr = new FileReader();
    fr.onload = () => {
      this.image = fr.result;
      this.render();
    };
    fr.readAsDataURL(file);
  }

  render() {
    if (this.image !== '') {
      $('#preview_image')
        .css('background-image', `url(${this.image})`)
        .show();
    }
  }
}
