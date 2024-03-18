// @flow
import JQueryView, { on } from '../../common/JQueryView';
import Chart from 'chart.js';
import StudentClient from '../../../models/students/StudentClient';
import ChartUtil from '../../../utils/ChartUtil';
import type { StudentAggregate } from '../../../models/students/StudentAggregate';

declare var $: any;

export default class StudentCountChartView extends JQueryView {
  studentClient = new StudentClient();
  students: Array<StudentAggregate> = [];

  constructor() {
    super('#student_count_chart_view');
    this.fetchStudents(1);
  }

  @on('click #2weeks')
  onClick2Weeks() {
    this.fetchStudents(1);
  }

  @on('click #3months')
  onClick3Months() {
    this.fetchStudents(7);
  }

  @on('click #year')
  onClickYear() {
    this.fetchStudents(30);
  }

  fetchStudents(term: number) {
    this.studentClient
      .fetchStudentAggregates(term)
      .then(response => {
        this.students = response.data;
        this.render();
      })
      .catch(error => {
        alert(error);
      });
  }

  render() {
    const context = $('#student_count_chart')
      .get(0)
      .getContext('2d');

    Chart.Line(context, {
      data: {
        labels: this.students.map(student => student.date),
        datasets: [
          {
            label: '全学生',
            backgroundColor: ChartUtil.colors.red,
            borderColor: ChartUtil.colors.red,
            fill: false,
            data: this.students.map(student => student.all_counts),
          },
          {
            label: '登録手続き中',
            backgroundColor: ChartUtil.colors.yellow,
            borderColor: ChartUtil.colors.yellow,
            fill: false,
            data: this.students.map(student => student.new_counts),
          },
          {
            label: '却下',
            backgroundColor: ChartUtil.colors.purple,
            borderColor: ChartUtil.colors.purple,
            fill: false,
            data: this.students.map(student => student.rejected_counts),
          },
        ],
      },
      options: {
        legend: {
          display: true,
        },
      },
    });
  }
}
