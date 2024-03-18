// @flow
import JQueryView from '../../common/JQueryView';
import Chart from 'chart.js';

declare var $: any;

export default class StudentHSChartView extends JQueryView {
  humanities: number;
  sciences: number;

  constructor(
    humanities: number,
    sciences: number,
  ) {
    super('#student_age_chart_view');
    this.humanities = humanities;
    this.sciences = sciences;
    this.render();
  }

  render() {
    const context = $('#student_HS_chart')
      .get(0)
      .getContext('2d');

    new Chart(context, {
      type: 'pie',
      data: {
        labels: ['文系', '理系'],
        datasets: [
          {
            data: [
              this.humanities,
              this.sciences,
            ],
            backgroundColor: [
              '#f39c12',
              '#00c0ef',
            ],
            hoverBackgroundColor: [
              '#f39c12',
              '#00c0ef',
            ],
          },
        ],
      },
    });
  }
}
