// @flow
import JQueryView, { on } from '../../common/JQueryView';
import Chart from 'chart.js';
import UserClient from '../../../models/users/UserClient';
import ChartUtil from '../../../utils/ChartUtil';
import type { UserAggregate } from '../../../models/users/UserAggregate';

declare var $: any;

export default class UserCountChartView extends JQueryView {
  userClient = new UserClient();
  users: Array<UserAggregate> = [];

  constructor() {
    super('#user_count_chart_view');
    this.fetchUsers(1);
  }

  @on('click #2weeks')
  onClick2Weeks() {
    this.fetchUsers(1);
  }

  @on('click #3months')
  onClick3Months() {
    this.fetchUsers(7);
  }

  @on('click #year')
  onClickYear() {
    this.fetchUsers(30);
  }

  fetchUsers(term: number) {
    this.userClient
      .fetchUserAggregates(term)
      .then(response => {
        this.users = response.data;
        this.render();
      })
      .catch(error => {
        alert(error);
      });
  }

  render() {
    const context = $('#user_count_chart')
      .get(0)
      .getContext('2d');

    Chart.Line(context, {
      data: {
        labels: this.users.map(user => user.date),
        datasets: [
          {
            label: '全ユーザ登録数',
            backgroundColor: ChartUtil.colors.orange,
            borderColor: ChartUtil.colors.orange,
            fill: false,
            data: this.users.map(user => user.all_user_counts),
          },
          {
            label: '全学生登録数',
            backgroundColor: ChartUtil.colors.red,
            borderColor: ChartUtil.colors.red,
            fill: false,
            data: this.users.map(user => user.all_counts),
          },
          {
            label: '全事業登録数',
            backgroundColor: ChartUtil.colors.purple,
            borderColor: ChartUtil.colors.purple,
            fill: false,
            data: this.users.map(user => user.all_company_counts),
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
