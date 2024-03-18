// @flow
import React from 'react';
import Slider from 'rc-slider';
import StudentClient from '../../../../models/students/StudentClient';

type Props = {
  student: any,
  history: any,
  min: number,
  max: number,
};

type State = {
  revision: number,
  history: any,
};

export default class IndexView extends React.Component<Props, State> {
  studentClient = new StudentClient();

  constructor(props: Props) {
    super(props);
    this.state = {
      revision: props.max,
      history: props.history,
    };
  }

  componentDidMount() {
    this.fetchHistory();
  }

  onClickPrev() {
    const { revision } = this.state;

    if (revision > this.props.min) {
      this.setState(
        {
          revision: revision - 1,
        },
        () => this.fetchHistory(),
      );
    }
  }

  onClickNext() {
    const { revision } = this.state;

    if (revision < this.props.max) {
      this.setState(
        {
          revision: revision + 1,
        },
        () => this.fetchHistory(),
      );
    }
  }

  fetchHistory() {
    this.studentClient
      .fetchHistory(this.props.student.id, this.state.revision)
      .then(response => {
        this.setState({ history: response.data });
      })
      .catch(error => {
        console.warn(error);
      });
  }

  render() {
    const { student, min, max } = this.props;
    const { history, revision } = this.state;

    return (
      <section className="content">
        <div className="mb-30">
          <div className="mb-20">
            <Slider
              min={parseInt(min)}
              max={parseInt(max)}
              step={1}
              dots={true}
              value={revision}
            />
          </div>
          <div className="clearfix">
            <div className="pull-left">
              <button
                className="btn btn-sm btn-info"
                disabled={revision === min ? 'disabled' : ''}
                onClick={() => this.onClickPrev()}
              >
                前へ
              </button>
            </div>
            <div className="pull-right">
              <button
                className="btn btn-sm btn-info"
                disabled={revision === max ? 'disabled' : ''}
                onClick={() => this.onClickNext()}
              >
                次へ
              </button>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-md-6">
            <div className="box">
              <div className="box-header with-border">
                <h3>現在の学生申請内容</h3>
                <i className="fa fa-clock-o" /> {student.updated_at}
              </div>
              <div className="box-body no-padding">
                <table className="table">
                  <tbody>
                    <tr className="bg-warning">
                      <th colSpan="2">基本情報</th>
                    </tr>
                    <tr
                      className={
                        student.full_name != history.full_name
                          ? 'bg-danger'
                          : ''
                      }
                    >
                      <th width="260px">氏名</th>
                      <td>{student.full_name}</td>
                    </tr>
                    <tr
                      className={
                        student.full_name_kana != history.full_name_kana
                          ? 'bg-danger'
                          : ''
                      }
                    >
                      <th>氏名（カナ）</th>
                      <td>{student.full_name_kana}</td>
                    </tr>
                    <tr
                      className={
                        student.gender != history.gender ? 'bg-danger' : ''
                      }
                    >
                      <th>性別</th>
                      <td>{student.gender}</td>
                    </tr>
                    <tr
                      className={
                        student.birth_on != history.birth_on ? 'bg-danger' : ''
                      }
                    >
                      <th>生年月日</th>
                      <td>{student.birth_on}</td>
                    </tr>
                    <tr
                      className={
                        student.zip_code != history.zip_code ? 'bg-danger' : ''
                      }
                    >
                      <th>郵便番号</th>
                      <td>{student.zip_code}</td>
                    </tr>
                    <tr
                      className={
                        student.prefecture != history.prefecture
                          ? 'bg-danger'
                          : ''
                      }
                    >
                      <th>都道府県</th>
                      <td>{student.prefecture}</td>
                    </tr>
                    <tr
                      className={
                        student.city != history.city ? 'bg-danger' : ''
                      }
                    >
                      <th>市区町村</th>
                      <td>{student.city}</td>
                    </tr>
                    <tr
                      className={
                        student.address1 != history.address1 ? 'bg-danger' : ''
                      }
                    >
                      <th>住所</th>
                      <td>{student.address1}</td>
                    </tr>
                    <tr
                      className={
                        student.address2 != history.address2 ? 'bg-danger' : ''
                      }
                    >
                      <th>建物名</th>
                      <td>{student.address2}</td>
                    </tr>
                    <tr
                      className={
                        student.phone != history.phone ? 'bg-danger' : ''
                      }
                    >
                      <th>自宅固定電話番号</th>
                      <td>{student.phone}</td>
                    </tr>
                    <tr
                      className={
                        student.phone_mobile != history.phone_mobile
                          ? 'bg-danger'
                          : ''
                      }
                    >
                      <th>携帯電話番号</th>
                      <td>{student.phone_mobile}</td>
                    </tr>
                  </tbody>
                </table>
                <table className="table">
                  <tbody>
                    <tr className="bg-warning">
                      <th colSpan="2">勤務先情報</th>
                    </tr>
                    <tr
                      className={student.job != history.job ? 'bg-danger' : ''}
                    >
                      <th width="260px">職業</th>
                      <td>{student.job}</td>
                    </tr>
                    <tr
                      className={
                        student.job_details != history.job_details
                          ? 'bg-danger'
                          : ''
                      }
                    >
                      <th>その他の詳細</th>
                      <td>{student.job_details}</td>
                    </tr>
                    <tr
                      className={student.business != history.business ? 'bg-danger' : ''}
                    >
                      <th width="260px">業種</th>
                      <td>{student.business}</td>
                    </tr>
                    <tr
                      className={student.business_details != history.business_details ? 'bg-danger' : ''}
                    >
                      <th width="260px">その他の詳細</th>
                      <td>{student.business_details}</td>
                    </tr>
                    <tr
                      className={
                        student.company != history.company ? 'bg-danger' : ''
                      }
                    >
                      <th>勤務先会社名</th>
                      <td>{student.company}</td>
                    </tr>
                    <tr
                      className={
                        student.phone_company != history.phone_company
                          ? 'bg-danger'
                          : ''
                      }
                    >
                      <th>勤務先電話番号</th>
                      <td>{student.phone_company}</td>
                    </tr>
                    <tr
                      className={
                        student.email_company != history.email_company
                          ? 'bg-danger'
                          : ''
                      }
                    >
                      <th>勤務先メールアドレス</th>
                      <td>{student.email_company}</td>
                    </tr>
                  </tbody>
                </table>

                <table className="table">
                  <tbody>
                    <tr className="bg-warning">
                      <th colSpan="2">振込口座</th>
                    </tr>
                    <tr
                      className={
                        student.bank != history.bank ? 'bg-danger' : ''
                      }
                    >
                      <th width="260px">金融機関</th>
                      <td>{student.bank}</td>
                    </tr>
                    <tr
                      className={
                        student.bank_branch != history.bank_branch
                          ? 'bg-danger'
                          : ''
                      }
                    >
                      <th>支店</th>
                      <td>{student.bank_branch}</td>
                    </tr>
                    <tr
                      className={
                        student.account_type != history.account_type
                          ? 'bg-danger'
                          : ''
                      }
                    >
                      <th>科目</th>
                      <td>{student.account_type}</td>
                    </tr>
                    <tr
                      className={
                        student.bank_account_number !=
                        history.bank_account_number
                          ? 'bg-danger'
                          : ''
                      }
                    >
                      <th>口座番号</th>
                      <td>{student.bank_account_number}</td>
                    </tr>
                    <tr
                      className={
                        student.bank_account_name != history.bank_account_name
                          ? 'bg-danger'
                          : ''
                      }
                    >
                      <th>口座番号</th>
                      <td>{student.bank_account_name}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
          <div className="col-md-6">
            <div className="box">
              <div className="box-header with-border">
                <h3>
                  リビジョン
                  {history.revision}
                </h3>
                <i className="fa fa-clock-o" /> {history.updated_at}
              </div>
              <div className="box-body no-padding">
                <table className="table">
                  <tbody>
                    <tr className="bg-warning">
                      <th colSpan="2">基本情報</th>
                    </tr>
                    <tr>
                      <th width="260px">氏名</th>
                      <td>{history.full_name}</td>
                    </tr>
                    <tr>
                      <th>氏名（カナ）</th>
                      <td>{history.full_name_kana}</td>
                    </tr>
                    <tr>
                      <th>性別</th>
                      <td>{history.gender}</td>
                    </tr>
                    <tr>
                      <th>生年月日</th>
                      <td>{history.birth_on}</td>
                    </tr>
                    <tr>
                      <th>郵便番号</th>
                      <td>{history.zip_code}</td>
                    </tr>
                    <tr>
                      <th>都道府県</th>
                      <td>{history.prefecture}</td>
                    </tr>
                    <tr>
                      <th>市区町村</th>
                      <td>{history.city}</td>
                    </tr>
                    <tr>
                      <th>住所</th>
                      <td>{history.address1}</td>
                    </tr>
                    <tr>
                      <th>建物名</th>
                      <td>{history.address2}</td>
                    </tr>
                    <tr>
                      <th>自宅固定電話番号</th>
                      <td>{history.phone}</td>
                    </tr>
                    <tr>
                      <th>携帯電話番号</th>
                      <td>{history.phone_mobile}</td>
                    </tr>
                  </tbody>
                </table>
                <table className="table">
                  <tbody>
                    <tr className="bg-warning">
                      <th colSpan="2">勤務先情報</th>
                    </tr>
                    <tr>
                      <th width="260px">職業</th>
                      <td>{history.job}</td>
                    </tr>
                    <tr>
                      <th>その他の詳細</th>
                      <td>{history.job_details}</td>
                    </tr>
                    <tr>
                      <th width="260px">業種</th>
                      <td>{history.business}</td>
                    </tr>
                    <tr>
                      <th>その他の詳細</th>
                      <td>{history.business_details}</td>
                    </tr>
                    <tr>
                      <th>勤務先会社名</th>
                      <td>{history.company}</td>
                    </tr>
                    <tr>
                      <th>勤務先電話番号</th>
                      <td>{history.phone_company}</td>
                    </tr>
                    <tr>
                      <th>勤務先メールアドレス</th>
                      <td>{history.email_company}</td>
                    </tr>
                  </tbody>
                </table>

                <table className="table">
                  <tbody>
                    <tr className="bg-warning">
                      <th colSpan="2">振込口座</th>
                    </tr>
                    <tr>
                      <th width="260px">金融機関</th>
                      <td>{history.bank}</td>
                    </tr>
                    <tr>
                      <th>支店</th>
                      <td>{history.bank_branch}</td>
                    </tr>
                    <tr>
                      <th>科目</th>
                      <td>{history.account_type}</td>
                    </tr>
                    <tr>
                      <th>口座番号</th>
                      <td>{history.bank_account_number}</td>
                    </tr>
                    <tr>
                      <th>口座番号</th>
                      <td>{history.bank_account_name}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
      </section>
    );
  }
}
