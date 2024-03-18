// @flow
import JQueryView, { on } from '../../common/JQueryView';

export default class FormView extends JQueryView {
  image: any;
  bgImage: any;

  constructor(image: string, bgImage: string) {
    super('.simple_form');
    this.image = image;
    this.bgImage = bgImage;
    this.render();
  }

  @on('change #slider_slider_type')
  onChangeSliderType() {
    this.render();
  }

  @on('change #slider_image')
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

  @on('change #slider_bg_image')
  onChangeBgImage(event: any) {
    if (!event.target.files.length) {
      return;
    }

    const file = $(event.target).prop('files')[0];
    const fr = new FileReader();
    fr.onload = () => {
      this.bgImage = fr.result;
      this.render();
    };
    fr.readAsDataURL(file);
  }

  render() {
    const sliderType = $('#slider_slider_type').val();

    $('.slider_project').toggle(sliderType === 'Project');
    $('.slider_event').toggle(sliderType === 'Event');
    $('.slider_headline').toggle(sliderType === 'Headline');
    $('.slider_image').toggle(sliderType === 'Headline');
    $('#preview_image')
      .css('background-image', `url(${this.image})`)
      .toggle(this.image !== '');
    $('#preview_bg_image')
      .css('background-image', `url(${this.bgImage})`)
      .toggle(this.bgImage !== '');
  }
}
