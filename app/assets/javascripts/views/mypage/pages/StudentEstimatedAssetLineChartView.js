// @flow
import JQueryView, { on } from '../../common/JQueryView';
import Chart from 'chart.js';
import StockHistoryClient from '../../../models/stock_histories/StockHistoryClient';
import moment from 'moment';
import type { ChartDataPoint } from '../../../models/stock_histories/ChartDataPoint';

export default class StudentEstimatedAssetLineChartView extends JQueryView {
  unit: string;

  stockHistoryClient = new StockHistoryClient();

  unit = 'month';
  stepSize = 1;
  data: Array<ChartDataPoint> = [];
  isMobile = window.matchMedia('only screen and (max-width: 760px)').matches;

  constructor() {
    super('#student_asset_line_chart');
    this.render();
    this.fetchStockHistory();
  }

  @on('change #company_selector')
  onChangeCompany(event: any) {
    const companyId = event.target.value;
    this.fetchStockHistory(companyId);
    this.render();
  }

  @on('click input[name="unit"]')
  onChangeUnit(event: any) {
    this.unit = event.target.value;
    this.render();
  }

  fetchStockHistory(companyId?: number) {
    this.stockHistoryClient.fetchStockHistory(companyId).then(res => {
      this.data = res.data.map(point => ({
        t: moment(point.time),
        y: point.value,
      }));
      this.render();
    });
  }

  render() {
    const canvas = $('#student_asset_line_chart_canvas').get(0);
    if (!(canvas instanceof HTMLCanvasElement)) return;
    const context = canvas.getContext('2d');

    let data = this.data.slice(0);

    let suggestedMaxForYAxis = undefined;
    if (data.length === 0 || data.every(point => point.y === 0))
      suggestedMaxForYAxis = 500000;

    if (!data[data.length - 1] || data[data.length - 1].t < moment()) {
      data.push({
        t: moment(),
        y: data[data.length - 1] ? data[data.length - 1].y : null,
      });
    }

    let stepCount;
    let stepWidth;
    const firstPointTime = data[0].t;
    const lastPointTime = data[data.length - 1].t;
    if (this.unit === 'year') {
      data.unshift({
        t: moment()
          .year(firstPointTime.year())
          .startOf('year'),
      });
      data.push({
        t: moment()
          .year(lastPointTime.year() + 1)
          .startOf('year'),
      });
      stepCount = moment(lastPointTime).diff(firstPointTime, 'years');
      stepWidth = 40;
      this.stepSize = 1;
    } else if (this.unit === 'month') {
      data.unshift({
        t: moment()
          .year(firstPointTime.year())
          .month(firstPointTime.month())
          .startOf('month'),
      });
      data.push({
        t: moment()
          .year(lastPointTime.year())
          .month(lastPointTime.month() + 1)
          .startOf('month'),
      });
      stepCount = moment(lastPointTime).diff(firstPointTime, 'months');
      stepWidth = 100;
      this.stepSize = 1;
    } else {
      data.unshift({
        t: firstPointTime.clone().add(1, 'day'),
      });
      stepCount = moment(lastPointTime).diff(firstPointTime, 'days');
      this.stepSize = 5;
      stepWidth = 50;
    }

    canvas.width = (stepCount / this.stepSize) * stepWidth;
    canvas.width += 50;

    let minWidth = null;
    if (this.isMobile) {
      canvas.height = 200;
      canvas.width = (canvas.width * 2) / 3;
      minWidth = screen.width - 40;
    } else {
      canvas.height = 300;
      minWidth = 400;
    }

    if (canvas.width < minWidth) {
      canvas.width = minWidth;
    }

    $('.chart-wrapper').get(0).scrollLeft = canvas.width;

    const chart = new Chart(context, {
      type: 'line',
      data: {
        datasets: [
          {
            data: data,
            steppedLine: true,
            backgroundColor: '#d7edfe',
            borderColor: '#2196F3',
            pointRadius: 0,
            xAxisID: 'time-axis',
          },
        ],
      },
      options: {
        legend: false,
        responsive: false,
        maintainAspectRation: false,
        animation: {
          duration: 1,
          onProgress: () => {
            const copyWidth = chart.scales['y-axis-0'].width - 10;
            const copyHeight =
              chart.scales['y-axis-0'].height +
              chart.scales['y-axis-0'].top +
              10;

            const scale = window.devicePixelRatio;

            const yAxisCanvas = document.getElementById('yAxis');
            if (!(yAxisCanvas instanceof HTMLCanvasElement)) return;
            const targetCtx = yAxisCanvas.getContext('2d');
            targetCtx.canvas.width = copyWidth;
            targetCtx.fillStyle = '#fff';
            let offset = 20;
            if (this.unit === 'day') {
              offset = 65;
            }
            if (this.isMobile) {
              offset += 100;
            }
            targetCtx.fillRect(
              0,
              0,
              targetCtx.canvas.width,
              targetCtx.canvas.height - offset,
            );
            targetCtx.drawImage(
              canvas,
              0,
              0,
              copyWidth * scale,
              copyHeight * scale,
              0,
              0,
              copyWidth,
              copyHeight,
            );
          },
          onComplete() {
            canvas.style.width = '';
          },
        },
        scales: {
          scaleLabel: {
            fontStyle: 'bold',
          },
          xAxes: [
            {
              id: 'time-axis',
              type: 'time',
              distribution: 'linear',
              time: {
                tooltipFormat: 'YYYY/MM/DD',
                unit: this.unit,
                displayFormats: {
                  day: 'YYYY/MM/DD',
                  month: 'YYYY/MM',
                  year: 'YYYY',
                },
                stepSize: this.stepSize,
              },
              gridLines: {
                display: true,
              },
            },
          ],
          yAxes: [
            {
              gridLines: {
                drawBorder: false,
                drawTicks: false,
              },
              ticks: {
                beginAtZero: true,
                padding: 10,
                suggestedMax: suggestedMaxForYAxis,
                callback(value) {
                  return value.toLocaleString();
                },
              },
            },
          ],
        },
      },
    });
  }
}
