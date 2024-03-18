// @flow
import JQueryView from '../../../common/JQueryView';
import Chart from 'chart.js';

declare var $: any;

export default class HiredGenderChartView extends JQueryView {
  male: number;
  female: number;

  constructor(male: number, female: number) {
    super('#hire_gender_chart_view');
    this.male = male;
    this.female = female;
    this.render();
  }

  render() {
    const context = $('#hire_gender_chart')
      .get(0)
      .getContext('2d');

    new Chart(context, {
      type: 'pie',
      data: {
        labels: ['男性', '女性'],
        datasets: [
          {
            data: [this.male, this.female],
            backgroundColor: ['#36A2EB', '#FF6384'],
            hoverBackgroundColor: ['#36A2EB', '#FF6384'],
          },
        ],
      },
    });
  }
}
