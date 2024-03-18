// @flow
import JQueryView from '../common/JQueryView';
import Chart from 'chart.js';

declare var $: any;

export default class GraphView extends JQueryView {
  canvas: string;
  values: Array<any>;

  constructor(id: number, values: Array<any>) {
    super(`#company_graph_view_${id}`);
    this.canvas = `#company_graph_${id}`;
    this.values = values;
    this.render();
  }

  render() {
    const context = $(this.canvas)
      .get(0)
      .getContext('2d');

    const data = {
      labels: this.values.map(v => v.label),
      datasets: [
        {
          borderWidth: 1,
          data: this.values.map(i => i.data),
          backgroundColor: 'rgba(54, 162, 235, 1)',
          borderColor: 'rgba(54, 162, 235, 1)',
        },
      ],
    };

    new Chart(context, {
      type: 'bar',
      data: data,
      options: {
        legend: {
          display: false,
        },
        scales: {
          xAxes: [
            {
              gridLines: {
                color: 'rgba(255,255,255,0.5)',
                zeroLineColor: 'rgba(255,255,255,0.5)',
              },
            },
          ],
          yAxes: [
            {
              ticks: {
                beginAtZero: true,
              },
            },
          ],
        },
      },
    });
  }
}
