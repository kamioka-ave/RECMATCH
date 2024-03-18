// @flow
import JQueryView from '../common/JQueryView';
import Chart from 'chart.js';

declare var $: any;

export default class StudentAgeChartView extends JQueryView {
  age20: number;
  age30: number;
  age40: number;
  age50: number;
  age60: number;
  age70: number;

  constructor(
    age20: number,
    age30: number,
    age40: number,
    age50: number,
    age60: number,
    age70: number,
  ) {
    super('#student_age_chart_view');
    this.age20 = age20;
    this.age30 = age30;
    this.age40 = age40;
    this.age50 = age50;
    this.age60 = age60;
    this.age70 = age70;
    this.render();
  }

  render() {
    const context = $('#student_age_chart')
      .get(0)
      .getContext('2d');
    new Chart(context, {
      type: 'pie',
      data: {
        labels: ['20代', '30代', '40代', '50代', '60代', '70代'],
        datasets: [
          {
            data: [
              this.age20,
              this.age30,
              this.age40,
              this.age50,
              this.age60,
              this.age70,
            ],
            backgroundColor: [
              '#67B843',
              '#97CB80',
              '#006934',
              '#009944',
              '#B0D014',
              '#A9A9AA',
            ],
            hoverBackgroundColor: [
              '#67B843',
              '#97CB80',
              '#006934',
              '#009944',
              '#B0D014',
              '#A9A9AA',
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
