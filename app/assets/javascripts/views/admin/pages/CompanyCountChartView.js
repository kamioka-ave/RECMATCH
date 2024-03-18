// @flow
import JQueryView, { on } from '../../common/JQueryView';
import Chart from 'chart.js';
import CompanyClient from '../../../models/companies/CompanyClient';
import ChartUtil from '../../../utils/ChartUtil';
import type { CompanyAggregate } from '../../../models/companies/CompanyAggregate';

declare var $: any;

export default class CompanyCountChartView extends JQueryView {
  companyClient = new CompanyClient();
  companies: Array<CompanyAggregate> = [];

  constructor() {
    super('#company_count_chart_view');
    this.fetchCompanies(1);
  }

  @on('click #2weeks')
  onClick2Weeks() {
    this.fetchCompanies(1);
  }

  @on('click #3months')
  onClick3Months() {
    this.fetchCompanies(7);
  }

  @on('click #year')
  onClickYear() {
    this.fetchCompanies(30);
  }

  fetchCompanies(term: number) {
    this.companyClient
      .fetchCompanyAggregates(term)
      .then(response => {
        this.companies = response.data;
        this.render();
      })
      .catch(error => {
        alert(error);
      });
  }

  render() {
    const context = $('#company_count_chart')
      .get(0)
      .getContext('2d');

    Chart.Line(context, {
      data: {
        labels: this.companies.map(company => company.date),
        datasets: [
          {
            label: '企業',
            backgroundColor: ChartUtil.colors.red,
            borderColor: ChartUtil.colors.red,
            fill: false,
            data: this.companies.map(company => company.all_counts),
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
