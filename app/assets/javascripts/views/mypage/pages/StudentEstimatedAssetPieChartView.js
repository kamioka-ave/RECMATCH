// @flow
import JQueryView from '../../common/JQueryView';
import Chart from 'chart.js';

export default class StudentEstimatedAssetPieChartView extends JQueryView {
  categories: any;
  data: any;

  constructor(dataStr: string) {
    const data = JSON.parse(dataStr);
    super('#student_asset_pie_chart');

    this.categories = data;
    const totalAssets = this.categories.reduce(
      (sum, category) => sum + category.assets,
      0,
    );
    this.data = {
      datasets: [
        {
          data: data.map(category =>
            ((category.assets / totalAssets) * 100).toFixed(1),
          ),
          backgroundColor: data.map(
            (_, index) => 'hsl(' + (360 * index) / data.length + ', 100%, 69%)',
          ),
        },
      ],
      labels: data.map(category => category.name),
    };
    this.data.datasets[0].data[data.length - 1] = (
      100 -
      this.data.datasets[0].data
        .slice(0, -1)
        .reduce((a, b) => parseFloat(a) + parseFloat(b), 0)
    ).toFixed(1);

    this.render();
  }

  render() {
    const context = $('#student_asset_pie_chart')
      .get(0)
      .getContext('2d');
    const chart = new Chart(context, {
      type: 'doughnut',
      data: this.data,
      options: {
        cutoutPercentage: 60,
        layout: {
          padding: {
            left: 40,
            right: 40,
            top: 20,
            bottom: 0,
          },
        },
        legend: false,
        legendCallback: () => {
          let legend = '';
          this.categories.forEach((category, index) => {
            const flag = `<span style="background-color: ${
              this.data.datasets[0].backgroundColor[index]
            }" class="chart-legend-flag"></span>`;
            legend += `
                <div class="col-xs-6">
                  ${flag}
                  <span class="chart-legend-label">
                    ${this.data.datasets[0].data[index]}% ${category.name}
                  </span>
                </div>`;
          });
          return legend;
        },
        tooltips: {
          callbacks: {
            label(tooltipItem, data) {
              const label = data.labels[tooltipItem.index] || '';
              const value = data.datasets[0].data[tooltipItem.index];
              return `${label} ${value}%`;
            },
          },
        },
        maintainAspectRatio: false,
      },
    });

    $('#student_asset_pie_chart_legend').html(chart.generateLegend());
  }
}
