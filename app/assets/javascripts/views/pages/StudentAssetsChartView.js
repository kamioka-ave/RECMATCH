// @flow
import JQueryView from '../common/JQueryView';
import Chart from 'chart.js';

declare var $: any;

export default class StudentAssetsChartView extends JQueryView {
  u300: number;
  u500: number;
  u1000: number;
  u3000: number;
  o3000: number;

  constructor(
    u300: number,
    u500: number,
    u1000: number,
    u3000: number,
    o3000: number,
  ) {
    super('#student_assets_chart_view');
    this.u300 = u300;
    this.u500 = u500;
    this.u1000 = u1000;
    this.u3000 = u3000;
    this.o3000 = o3000;
    this.render();
  }

  render() {
    const context = $('#student_assets_chart')
      .get(0)
      .getContext('2d');
    new Chart(context, {
      type: 'pie',
      data: {
        labels: [
          '300万円未満',
          '300万円〜499万円',
          '500万円〜999万円',
          '1000万円〜2999万円',
          '3000万円以上',
        ],
        datasets: [
          {
            data: [this.u300, this.u500, this.u1000, this.u3000, this.o3000],
            backgroundColor: [
              '#76C1E5',
              '#A1D7DF',
              '#004662',
              '#5399B7',
              '#BABBBB',
            ],
            hoverBackgroundColor: [
              '#76C1E5',
              '#A1D7DF',
              '#004662',
              '#5399B7',
              '#BABBBB',
            ],
          },
        ],
      },
      options: {
        legend: {
          display: true,
          position: 'right',
        },
        tooltips: {
          callbacks: {
            label: (tooltipItem, data) => {
              const dataset = data.datasets[tooltipItem.datasetIndex];
              const total = dataset.data.reduce(
                (previousValue, currentValue) => previousValue + currentValue,
              );
              const currentValue = dataset.data[tooltipItem.index];
              const percentage = Math.floor((currentValue / total) * 100 + 0.5);
              return percentage + '%';
            },
          },
        },
      },
    });
  }
}
