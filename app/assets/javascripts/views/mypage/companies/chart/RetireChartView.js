// @flow
import JQueryView from '../../../common/JQueryView';
import Chart from 'chart.js';

declare var $: any;

export default class RetireChartView extends JQueryView {
  employee: number;
  retired: number;

  constructor(employee: number, retired: number) {
    super('#retire_chart_view');
    this.employee = employee;
    this.retired = retired;
    this.render();
  }

  render() {
    const context = $('#retire_chart')
      .get(0)
      .getContext('2d');

    new Chart(context, {
      type: 'pie',
      data: {
        labels: ['在籍社員', '離職者'],
        datasets: [
          {
            data: [this.employee, this.retired],
            backgroundColor: ['#FFFFAA', '#CCCCCC'],
            hoverBackgroundColor: ['#FFFFAA', '#CCCCCC'],
          },
        ],
      },
    });
  }
}
