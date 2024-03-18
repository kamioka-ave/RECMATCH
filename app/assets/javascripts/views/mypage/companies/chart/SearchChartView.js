// @flow
import JQueryView, { on } from '../../../common/JQueryView';
import Chart from 'chart.js';

declare var $: any;

export default class SearchChartView extends JQueryView {
  ability_1: number;
  ability_2: number;
  ability_3: number;
  ability_4: number;
  ability_5: number;
  ability_6: number;


  constructor(ability_1: number, ability_2: number, ability_3: number, ability_4: number, ability_5: number, ability_6: number) {
    super('#gender_chart_view');
    this.ability_1 = ability_1;
    this.ability_2 = ability_2;
    this.ability_3 = ability_3;
    this.ability_4 = ability_4;
    this.ability_5 = ability_5;
    this.ability_6 = ability_6;
    this.render();
  }

  @on('change input[name="search_student[communication]"]')
  onChangeCommunication() {
    alert("aaa");
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
    $(document).ready(function(){
      if( $('#search_student_communication').prop('checked') ){
        data1++;
      }
      if( $('#search_student_chalenge').prop('checked') ){
        data2++;
      }
      if( $('#search_student_commit').prop('checked') ){
        data3++;
      }
      if( $('#search_student_leader').prop('checked') ){
        data4++;
      }
      if( $('#search_student_teamwork').prop('checked') ){
        data5++;
      }
      if( $('#search_student_logical').prop('checked') ){
        data6++;
      }
      chart.data.datasets[0].data[0] = 1 + data1%2 * 2.5;
      chart.data.datasets[0].data[1] = 1 + data2%2 * 2.5;
      chart.data.datasets[0].data[2] = 1 + data3%2 * 2.5;
      chart.data.datasets[0].data[3] = 1 + data4%2 * 2.5;
      chart.data.datasets[0].data[4] = 1 + data5%2 * 2.5;
      chart.data.datasets[0].data[5] = 1 + data6%2 * 2.5;
      chart.update();
    });
    $(document).on('change','#search_student_communication',function(){
      data1++;
      chart.data.datasets[0].data[0] = 1 + data1%2 * 2.5;
      chart.data.datasets[0].data[1] = 1 + data2%2 * 2.5;
      chart.data.datasets[0].data[2] = 1 + data3%2 * 2.5;
      chart.data.datasets[0].data[3] = 1 + data4%2 * 2.5;
      chart.data.datasets[0].data[4] = 1 + data5%2 * 2.5;
      chart.data.datasets[0].data[5] = 1 + data6%2 * 2.5;
      chart.update();
    });
    $(document).on('change','#search_student_chalenge',function(){
        data2++;
        chart.data.datasets[0].data[0] = 1 + data1%2 * 2.5;
        chart.data.datasets[0].data[1] = 1 + data2%2 * 2.5;
        chart.data.datasets[0].data[2] = 1 + data3%2 * 2.5;
        chart.data.datasets[0].data[3] = 1 + data4%2 * 2.5;
        chart.data.datasets[0].data[4] = 1 + data5%2 * 2.5;
        chart.data.datasets[0].data[5] = 1 + data6%2 * 2.5;
        chart.update();
      });
    $(document).on('change','#search_student_commit',function(){
        data3++;
        chart.data.datasets[0].data[0] = 1 + data1%2 * 2.5;
        chart.data.datasets[0].data[1] = 1 + data2%2 * 2.5;
        chart.data.datasets[0].data[2] = 1 + data3%2 * 2.5;
        chart.data.datasets[0].data[3] = 1 + data4%2 * 2.5;
        chart.data.datasets[0].data[4] = 1 + data5%2 * 2.5;
        chart.data.datasets[0].data[5] = 1 + data6%2 * 2.5;
        chart.update();
      });
    $(document).on('change','#search_student_leader',function(){
        data4++;
        chart.data.datasets[0].data[0] = 1 + data1%2 * 2.5;
        chart.data.datasets[0].data[1] = 1 + data2%2 * 2.5;
        chart.data.datasets[0].data[2] = 1 + data3%2 * 2.5;
        chart.data.datasets[0].data[3] = 1 + data4%2 * 2.5;
        chart.data.datasets[0].data[4] = 1 + data5%2 * 2.5;
        chart.data.datasets[0].data[5] = 1 + data6%2 * 2.5;
        chart.update();
      });
    $(document).on('change','#search_student_teamwork',function(){
        data5++;
        chart.data.datasets[0].data[0] = 1 + data1%2 * 2.5;
        chart.data.datasets[0].data[1] = 1 + data2%2 * 2.5;
        chart.data.datasets[0].data[2] = 1 + data3%2 * 2.5;
        chart.data.datasets[0].data[3] = 1 + data4%2 * 2.5;
        chart.data.datasets[0].data[4] = 1 + data5%2 * 2.5;
        chart.data.datasets[0].data[5] = 1 + data6%2 * 2.5;
        chart.update();
      });
    $(document).on('change','#search_student_logical',function(){
        data6++;
        chart.data.datasets[0].data[0] = 1 + data1%2 * 2.5;
        chart.data.datasets[0].data[1] = 1 + data2%2 * 2.5;
        chart.data.datasets[0].data[2] = 1 + data3%2 * 2.5;
        chart.data.datasets[0].data[3] = 1 + data4%2 * 2.5;
        chart.data.datasets[0].data[4] = 1 + data5%2 * 2.5;
        chart.data.datasets[0].data[5] = 1 + data6%2 * 2.5;
        chart.update();
      });

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