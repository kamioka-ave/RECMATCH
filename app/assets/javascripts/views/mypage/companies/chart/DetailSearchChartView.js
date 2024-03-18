// @flow
import JQueryView, { on } from '../../../common/JQueryView';
import Chart from 'chart.js';

declare var $: any;

export default class DetailSearchChartView extends JQueryView {
  ability_1: number;
  ability_2: number;
  ability_3: number;
  ability_4: number;
  ability_5: number;
  ability_6: number;


  constructor(ability_1: number, ability_2: number, ability_3: number, ability_4: number, ability_5: number, ability_6: number) {
    super('#canvasChart');
    this.ability_1 = ability_1;
    this.ability_2 = ability_2;
    this.ability_3 = ability_3;
    this.ability_4 = ability_4;
    this.ability_5 = ability_5;
    this.ability_6 = ability_6;
    this.render();
  }

  render() {

    $('#collapseAbility-btn').on('click',function(){
      var chack = $("#collapseAbility").attr("aria-expanded")
      if( chack == "false" ){
        $('button#collapseAbility-btn i').removeClass('fa-angle-double-down');
        $('button#collapseAbility-btn i').addClass('fa-angle-double-up');
      }else{
        $('button#collapseAbility-btn i').removeClass('fa-angle-double-up');
        $('button#collapseAbility-btn i').addClass('fa-angle-double-down');
      }
    });
    var data1 = 0;var data2 = 0;var data3 = 0;var data4 = 0;var data5 = 0;var data6 = 0;

    var colorSet = {
      red: 'rgb(255, 99, 132)',
      orange: 'rgb(255, 159, 64)',
      yellow: 'rgb(255, 205, 86)',
      green: 'rgb(75, 192, 192)',
      blue: 'rgb(54, 162, 235)',
      purple: 'rgb(153, 102, 255)',
      grey: 'rgb(201, 203, 207)'
    };
    var color = Chart.helpers.color;
    const context = $('#canvasChart')
      .get(0)
      .getContext('2d');

    var chart = new Chart(context, {
      type: 'radar',
      data: {
        labels: ['コミュニケーション能力', 'チャレンジ精神', 'コミット力', 'リーダシップ力', 'チームワーク力', '論理的思考力'],
        datasets: [
          {
        	label: "能力",
            data: [this.ability_1, this.ability_2, this.ability_3, this.ability_4, this.ability_5, this.ability_6],
            backgroundColor: color(colorSet.red).alpha(0.5).rgbString(),
            borderColor: colorSet.red,
            pointBackgroundColor: colorSet.red,
          },
        ],
      },
      options: {
        scale: {
          display: true,
          pointLabels: {
          fontSize: 10,
          fontColor: colorSet.yellow
          },
          ticks: {
            display: true,
            fontSize: 15,
            fontColor: colorSet.green,
            min: 0,
            max: 5,
            beginAtZero: true
          },
          gridLines: {
            display: true,
            color: colorSet.yellow
          }
        }
      },
    });
  }
}