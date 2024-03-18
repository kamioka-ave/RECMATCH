// @flow
import AxiosClient from '../AxiosClient';
import type { AxiosPromise } from 'axios';
import type { StudentAggregate } from './StudentAggregate';

export default class StudentClient extends AxiosClient {
  fetchStudentAggregates(
    term: number,
  ): AxiosPromise<Array<StudentAggregate>> {
    return this.buildClient().get('/recmatchadmin20180830/student_aggregates.json', {
      params: {
        term: term,
      },
    });
  }

  fetchHistory(id: number, revision: number): Promise<any> {
    return this.buildClient().get(
      `/recmatchadmin20180830/students/${id}/histories/${revision}.json`,
    );
  }

  fetchInterviewHistory(id: number, revision: number): Promise<any> {
    return this.buildClient().get(
      `/recmatchadmin20180830/students/${id}/interview/histories/${revision}.json`,
    );
  }
  fetchPepHistory(id: number, revision: number): Promise<any> {
    return this.buildClient().get(`/recmatchadmin20180830/students/${id}/pep/histories/${revision}.json`);
  }
}
