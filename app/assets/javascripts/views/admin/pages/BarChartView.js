// @flow
import JQueryView from '../../common/JQueryView';
import Chart from 'chart.js';

declare var $: any;

export default class BarChartView extends JQueryView {
  canvas: string;
  interests: Array<any>;

  constructor(el: string, canvas: string, interests: Array<any>) {
    super(el);
    this.canvas = canvas;
    this.interests = interests.sort((a, b) => b.value - a.value);
    this.render();
  }

  render() {
    const context = $(this.canvas)
      .get(0)
      .getContext('2d');
    new Chart(context, {
      type: 'bar',
      data: {
        labels: this.interests.map(i => i.name),
        datasets: [
          {
            borderWidth: 1,
            data: this.interests.map(i => i.value),
          },
        ],
      },
      options: {
        legend: {
          display: false,
        },
      },
    });
  }
}
