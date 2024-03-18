// @flow
import React from 'react';
import Slider from 'rc-slider';
import renderHTML from 'react-render-html';
import ProjectClient from '../../../../../models/projects/ProjectClient';
import {
  date,
  datetime,
  delimited,
  filename,
} from '../../../../../helpers/ApplicationHelper';

type Props = {
  draft: any,
  history: any,
  min: number,
  max: number,
};

type State = {
  revision: number,
  history: any,
};

export default class IndexView extends React.Component<Props, State> {
  projectClient = new ProjectClient();

  constructor(props: Props) {
    super(props);

    this.state = {
      revision: props.max,
      history: props.history,
    };
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
    this.projectClient
      .fetchHistory(this.props.draft.id, this.state.revision)
      .then(response => {
        this.setState({ history: response.data });
      })
      .catch(error => {
        console.warn(error);
      });
  }

  render() {
    const { draft, min, max } = this.props;
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
                <h4>現在のプロジェクト</h4>
                <i className="fa fa-clock-o" /> {datetime(draft.updated_at)}
              </div>
              <div className="box-body">
                <dl>
                  <dt>プロジェクト名</dt>
                  <dd>{draft.name}</dd>
                  <dt>企業</dt>
                  <dd>{draft.company.name}</dd>
                  <dt>プロジェクトの概要</dt>
                  <dd>{draft.short_description}</dd>
                </dl>
              </div>
            </div>
          </div>

          <div className="col-md-6">
            <div className="box">
              <div className="box-header with-border">
                <h4>
                  リビジョン
                  {history.revision}
                </h4>
                <i className="fa fa-clock-o" /> {datetime(history.updated_at)}
              </div>
              <div className="box-body">
                <dl>
                  <dt>プロジェクト名</dt>
                  <dd>{history.name}</dd>
                  <dt>企業</dt>
                  <dd>{history.company.name}</dd>
                  <dt>プロジェクトの概要</dt>
                  <dd>{history.short_description}</dd>
                </dl>
              </div>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-md-6">
            <div className="box">
              <div className="box-header with-border">
                <h2 className="box-title">基本情報</h2>
              </div>
              <div className="box-body">
                <dl>
                  <dt
                    className={
                      draft.solicit !== history.solicit ? 'text-danger' : ''
                    }
                  >
                    募集金額
                  </dt>
                  <dd>{delimited(draft.solicit)}</dd>
                  <dt
                    className={
                      draft.solicit_limit !== history.solicit_limit
                        ? 'text-danger'
                        : ''
                    }
                  >
                    上限応募額
                  </dt>
                  <dd>{delimited(draft.solicit_limit)}</dd>
                  <dt
                    className={
                      draft.stock_price !== history.stock_price
                        ? 'text-danger'
                        : ''
                    }
                  >
                    1株あたりの価格
                  </dt>
                  <dd>{delimited(draft.stock_price)}</dd>
                  <dt
                    className={
                      draft.start_at !== history.start_at ? 'text-danger' : ''
                    }
                  >
                    申込開始日時
                  </dt>
                  <dd>{datetime(draft.start_at)}</dd>
                  <dt
                    className={
                      draft.finish_at !== history.finish_at ? 'text-danger' : ''
                    }
                  >
                    申込締切日時
                  </dt>
                  <dd>{datetime(draft.finish_at)}</dd>
                  <dt
                    className={
                      draft.start_on !== history.start_on ? 'text-danger' : ''
                    }
                  >
                    有価証券通知書の申込期間開始日
                  </dt>
                  <dd>{datetime(draft.start_on)}</dd>
                  <dt
                    className={
                      draft.shareholder_meeting_on !==
                      history.shareholder_meeting_on
                        ? 'text-danger'
                        : ''
                    }
                  >
                    株主総会（株式割当通知書に記載するもの）
                  </dt>
                  <dd>
                    {draft.shareholder_meeting_on != null
                      ? date(draft.shareholder_meeting_on)
                      : ''}
                  </dd>
                  <dt
                    className={
                      draft.is_temporarily_shareholder_meeting !==
                      history.is_temporarily_shareholder_meeting
                        ? 'text-danger'
                        : ''
                    }
                  >
                    臨時の株主総会か？
                  </dt>
                  <dd>
                    {draft.is_temporarily_shareholder_meeting
                      ? 'はい'
                      : 'いいえ'}
                  </dd>
                  <dt
                    className={
                      draft.board_meeting_on !== history.board_meeting_on
                        ? 'text-danger'
                        : ''
                    }
                  >
                    取締役会（株式割当通知書に記載するもの）
                  </dt>
                  <dd>
                    {draft.board_meeting_on != null
                      ? date(draft.board_meeting_on)
                      : ''}
                  </dd>
                  <dt
                    className={
                      draft.agreement_on !== history.agreement_on
                        ? 'text-danger'
                        : ''
                    }
                  >
                    募集取扱締結日
                  </dt>
                  <dd>
                    {draft.agreement_on != null ? date(draft.agreement_on) : ''}
                  </dd>
                  <dt
                    className={
                      draft.deliv_start_on !== history.deliv_start_on
                        ? 'text-danger'
                        : ''
                    }
                  >
                    払込期間（開始日）
                  </dt>
                  <dd>
                    {draft.deliv_start_on != null
                      ? date(draft.deliv_start_on)
                      : ''}
                  </dd>
                  <dt
                    className={
                      draft.deliv_end_on !== history.deliv_end_on
                        ? 'text-danger'
                        : ''
                    }
                  >
                    払込期間（終了日）
                  </dt>
                  <dd>
                    {draft.deliv_end_on != null ? date(draft.deliv_end_on) : ''}
                  </dd>
                  <dt
                    className={
                      draft.deliv_start_changed_on !==
                      history.deliv_start_changed_on
                        ? 'text-danger'
                        : ''
                    }
                  >
                    変更後の払込期間（開始日）
                  </dt>
                  <dd>
                    {draft.deliv_start_changed_on != null
                      ? date(draft.deliv_start_changed_on)
                      : ''}
                  </dd>
                  <dt
                    className={
                      draft.deliv_end_changed_on !==
                      history.deliv_end_changed_on
                        ? 'text-danger'
                        : ''
                    }
                  >
                    変更後の払込期間（終了日）
                  </dt>
                  <dd>
                    {draft.deliv_end_changed_on != null
                      ? date(draft.deliv_end_changed_on)
                      : ''}
                  </dd>
                  <dt
                    className={
                      draft.contract_before_type !==
                      history.contract_before_type
                        ? 'text-danger'
                        : ''
                    }
                  >
                    契約締結前交付書面の表示方法
                  </dt>
                  <dd>{draft.contract_before_type}</dd>
                  {draft.contract_before_type === 'PDF' && (
                    <dt>契約締結前交付書面</dt>
                  )}
                  {draft.contract_before_type === 'PDF' && (
                    <dd
                      className={
                        filename(draft.contract_before_url) !==
                        filename(history.contract_before_url)
                          ? 'bg-danger'
                          : ''
                      }
                    >
                      {draft.contract_before_url && (
                        <a href={draft.contract_before_url}>開く</a>
                      )}
                    </dd>
                  )}
                  <dt
                    className={
                      filename(draft.law_notification) !==
                      filename(history.law_notification)
                        ? 'text-danger'
                        : ''
                    }
                  >
                    会社法203条1項及び会社法施行規則42条に基づく通知
                  </dt>
                  <dd>
                    {draft.law_notification && (
                      <a href={draft.law_notification}>開く</a>
                    )}
                  </dd>
                  <dt>カバー画像</dt>
                  <dd>
                    {draft.image_thumb_url && (
                      <img src={draft.image_thumb_url} width={192} />
                    )}
                  </dd>
                  <dt>プロフィール画像</dt>
                  <dd>
                    {draft.profile_image_thumb_url && (
                      <img src={draft.profile_image_thumb_url} width={192} />
                    )}
                  </dd>
                  <dt>社判</dt>
                  <dd>
                    {draft.stamp_thumb_url && (
                      <img src={draft.stamp_thumb_url} width={192} />
                    )}
                  </dd>
                </dl>
              </div>
            </div>
          </div>
          <div className="col-md-6">
            <div className="box">
              <div className="box-header with-border">
                <h2 className="box-title">基本情報</h2>
              </div>
              <div className="box-body">
                <dl>
                  <dt>募集金額</dt>
                  <dd>{delimited(history.solicit)}</dd>
                  <dt>上限応募額</dt>
                  <dd>{delimited(history.solicit_limit)}</dd>
                  <dt>1株あたりの価格</dt>
                  <dd>{delimited(history.stock_price)}</dd>
                  <dt>申込開始日時</dt>
                  <dd>{datetime(history.start_at)}</dd>
                  <dt>申込締切日時</dt>
                  <dd>{datetime(history.finish_at)}</dd>
                  <dt>有価証券通知書の申込期間開始日</dt>
                  <dd>{datetime(history.start_on)}</dd>
                  <dt>株主総会（株式割当通知書に記載するもの）</dt>
                  <dd>
                    {history.shareholder_meeting_on != null
                      ? date(history.shareholder_meeting_on)
                      : ''}
                  </dd>
                  <dt>臨時の株主総会か？</dt>
                  <dd>
                    {history.is_temporarily_shareholder_meeting
                      ? 'はい'
                      : 'いいえ'}
                  </dd>
                  <dt>取締役会（株式割当通知書に記載するもの）</dt>
                  <dd>
                    {history.board_meeting_on != null
                      ? date(history.board_meeting_on)
                      : ''}
                  </dd>
                  <dt>募集取扱締結日</dt>
                  <dd>
                    {history.agreement_on != null
                      ? date(history.agreement_on)
                      : ''}
                  </dd>
                  <dt>払込期間（開始日）</dt>
                  <dd>
                    {history.deliv_start_on != null
                      ? date(history.deliv_start_on)
                      : ''}
                  </dd>
                  <dt>払込期間（終了日）</dt>
                  <dd>
                    {history.deliv_end_on != null
                      ? date(history.deliv_end_on)
                      : ''}
                  </dd>
                  <dt>変更後の払込期間（開始日）</dt>
                  <dd>
                    {history.deliv_start_changed_on != null
                      ? date(history.deliv_start_changed_on)
                      : ''}
                  </dd>
                  <dt>変更後の払込期間（終了日）</dt>
                  <dd>
                    {history.deliv_end_changed_on != null
                      ? date(history.deliv_end_changed_on)
                      : ''}
                  </dd>
                  <dt>契約締結前交付書面の表示方法</dt>
                  <dd>{history.contract_before_type}</dd>
                  {history.contract_before_type === 'PDF' && (
                    <dt>契約締結前交付書面</dt>
                  )}
                  {history.contract_before_type === 'PDF' && (
                    <dd>
                      {history.contract_before_url && (
                        <a href={history.contract_before_url}>開く</a>
                      )}
                    </dd>
                  )}
                  <dt>会社法203条1項及び会社法施行規則42条に基づく通知</dt>
                  <dd>
                    {history.law_notification && (
                      <a href={history.law_notification}>開く</a>
                    )}
                  </dd>
                  <dt>カバー画像</dt>
                  <dd>
                    {history.image_thumb_url && (
                      <img src={history.image_thumb_url} width={192} />
                    )}
                  </dd>
                  <dt>社判</dt>
                  <dd>
                    {history.stamp_thumb_url && (
                      <img src={history.stamp_thumb_url} width={192} />
                    )}
                  </dd>
                </dl>
              </div>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-md-6">
            {history.contract_before_type === 'HTML' && (
              <div className="box">
                <div className="box-header with-border">
                  <h2 className="box-title">契約締結前交付書面に必要な情報</h2>
                </div>
                <div className="box-body">
                  <dl>
                    <dt
                      className={
                        draft.capital !== history.capital ? 'text-danger' : ''
                      }
                    >
                      資本金（円）
                    </dt>
                    <dd>{delimited(draft.solicit)}</dd>
                    <dt
                      className={
                        draft.transcript_submitted_on !==
                        history.capital_submitted_on
                          ? 'text-danger'
                          : ''
                      }
                    >
                      資本金の日付
                    </dt>
                    <dd>{date(draft.capital_submitted_on)}</dd>
                    <dt
                      className={
                        draft.issued_stock !== history.issued_stock
                          ? 'text-danger'
                          : ''
                      }
                    >
                      発行済株式総数（株）
                    </dt>
                    <dd>{delimited(draft.issued_stock)}</dd>
                    <dt
                      className={
                        draft.transcript_submitted_on !==
                        history.transcript_submitted_on
                          ? 'text-danger'
                          : ''
                      }
                    >
                      発行済株式総数の日付
                    </dt>
                    <dd>{date(draft.transcript_submitted_on)}</dd>
                    <dt
                      className={
                        draft.issuable_stocks !== history.issuable_stocks
                          ? 'text-danger'
                          : ''
                      }
                    >
                      発行可能株式総数（株）
                    </dt>
                    <dd>{delimited(draft.issuable_stocks)}</dd>
                    <dt
                      className={
                        draft.stock_price_for_reserve !==
                        history.stock_price_for_reserve
                          ? 'text-danger'
                          : ''
                      }
                    >
                      1株あたりの資本準備金増加額（円）
                    </dt>
                    <dd>{delimited(draft.stock_price_for_reserve)}</dd>
                    <dt
                      className={
                        draft.support_phone !== history.support_phone
                          ? 'text-danger'
                          : ''
                      }
                    >
                      電話番号
                    </dt>
                    <dd>{draft.support_phone}</dd>
                    <dt
                      className={
                        draft.support_email !== history.support_email
                          ? 'text-danger'
                          : ''
                      }
                    >
                      メールアドレス
                    </dt>
                    <dd>{draft.support_email}</dd>
                    <dt>代表者</dt>
                    <dd>
                      {draft.company_presidents.map(president => (
                        <div key={president.id}>
                          {president.position} {president.full_name}
                        </div>
                      ))}
                    </dd>
                    <dt
                      className={
                        draft.risk_summery !== history.risk_summery
                          ? 'text-danger'
                          : ''
                      }
                    >
                      {draft.company.name}
                      に投資するに当たってのリスク
                    </dt>
                    <dd className="pre-scrollable">
                      {draft.risk_summery != null
                        ? renderHTML(draft.risk_summery)
                        : ''}
                    </dd>
                    <dt
                      className={
                        draft.how_to_use !== history.how_to_use
                          ? 'text-danger'
                          : ''
                      }
                    >
                      資金使徒
                    </dt>
                    <dd className="pre-scrollable">
                      {draft.how_to_use != null
                        ? renderHTML(draft.how_to_use)
                        : ''}
                    </dd>
                    <dt
                      className={
                        draft.transfer_restriction !==
                        history.transfer_restriction
                          ? 'text-danger'
                          : ''
                      }
                    >
                      募集株式の譲渡制限（金融商品取引契約の概要・企業情報・募集事項の内容等の12）
                    </dt>
                    <dd>{draft.transfer_restriction}</dd>
                    <dt
                      className={
                        draft.company_summery !== history.company_summery
                          ? 'text-danger'
                          : ''
                      }
                    >
                      募集株式の発行者の概況（金融商品取引契約の概要・企業情報・募集事項の内容等の13）
                    </dt>
                    <dd>{draft.company_summery}</dd>
                    <dt
                      className={
                        draft.business_plan !== history.business_plan
                          ? 'text-danger'
                          : ''
                      }
                    >
                      事業計画の内容（金融商品取引契約の概要・企業情報・募集事項の内容等の17）
                    </dt>
                    <dd>{draft.business_plan}</dd>
                    <dt
                      className={
                        draft.finance_condition !== history.finance_condition
                          ? 'text-danger'
                          : ''
                      }
                    >
                      発行者の財務状況（電子申込型電子募集取扱業務等に関する事項の3-2）
                    </dt>
                    <dd className="pre-scrollable">
                      {draft.finance_condition != null
                        ? renderHTML(draft.finance_condition)
                        : ''}
                    </dd>
                    <dt
                      className={
                        draft.business_plan_validity !==
                        history.business_plan_validity
                          ? 'text-danger'
                          : ''
                      }
                    >
                      発行者の事業計画の妥当性（電子申込型電子募集取扱業務等に関する事項の3-3）
                    </dt>
                    <dd className="pre-scrollable">
                      {draft.business_plan_validity != null
                        ? renderHTML(draft.business_plan_validity)
                        : ''}
                    </dd>
                    <dt
                      className={
                        draft.company_eligibility !==
                        history.company_eligibility
                          ? 'text-danger'
                          : ''
                      }
                    >
                      発行者の法令遵守状況を含めた適格性の3（電子申込型電子募集取扱業務等に関する事項の3-4-3）
                    </dt>
                    <dd>{draft.company_eligibility}</dd>
                    <dt
                      className={
                        draft.stake !== history.stake ? 'text-danger' : ''
                      }
                    >
                      当社と発行者との利害関係の状況（電子申込型電子募集取扱業務等に関する事項の3-5）
                    </dt>
                    <dd className="pre-scrollable">
                      {draft.stake != null ? renderHTML(draft.stake) : ''}
                    </dd>
                    <dt
                      className={
                        draft.governance_system !== history.governance_system
                          ? 'text-danger'
                          : ''
                      }
                    >
                      事業継続体制及びコーポレートガバナンス体制（電子申込型電子募集取扱業務等に関する事項の3-6）
                    </dt>
                    <dd className="pre-scrollable">
                      {draft.governance_system != null
                        ? renderHTML(draft.governance_system)
                        : ''}
                    </dd>
                    <dt>別紙用の画像</dt>
                    <dd>
                      {draft.contract_images.map(image => (
                        <div key={image.id}>
                          <img src={image.image_thumb_url} width={192} />
                        </div>
                      ))}
                    </dd>
                  </dl>
                </div>
              </div>
            )}
          </div>
          <div className="col-md-6">
            {draft.contract_before_type === 'HTML' && (
              <div className="box">
                <div className="box-header with-border">
                  <h2 className="box-title">契約締結前交付書面に必要な情報</h2>
                </div>
                <div className="box-body">
                  <dl>
                    <dt>資本金（円）</dt>
                    <dd>{delimited(history.solicit)}</dd>
                    <dt>資本金の日付</dt>
                    <dd>{date(history.capital_submitted_on)}</dd>
                    <dt>発行済株式総数（株）</dt>
                    <dd>{delimited(history.issued_stock)}</dd>
                    <dt>発行済株式総数の日付</dt>
                    <dd>{date(history.transcript_submitted_on)}</dd>
                    <dt>発行可能株式総数（株）</dt>
                    <dd>{delimited(history.issuable_stocks)}</dd>
                    <dt>1株あたりの資本準備金増加額（円）</dt>
                    <dd>{delimited(history.stock_price_for_reserve)}</dd>
                    <dt>電話番号</dt>
                    <dd>{history.support_phone}</dd>
                    <dt>メールアドレス</dt>
                    <dd>{history.support_email}</dd>
                    <dt>代表者</dt>
                    <dd>
                      {history.company_presidents.map(president => (
                        <div key={president.id}>
                          {president.position} {president.full_name}
                        </div>
                      ))}
                    </dd>
                    <dt>
                      {history.company.name}
                      に投資するに当たってのリスク
                    </dt>
                    <dd className="pre-scrollable">
                      {history.risk_summery != null
                        ? renderHTML(history.risk_summery)
                        : ''}
                    </dd>
                    <dt>資金使徒</dt>
                    <dd className="pre-scrollable">
                      {history.how_to_use != null
                        ? renderHTML(history.how_to_use)
                        : ''}
                    </dd>
                    <dt>
                      募集株式の譲渡制限（金融商品取引契約の概要・企業情報・募集事項の内容等の12）
                    </dt>
                    <dd>{history.transfer_restriction}</dd>
                    <dt>
                      募集株式の発行者の概況（金融商品取引契約の概要・企業情報・募集事項の内容等の13）
                    </dt>
                    <dd>{history.company_summery}</dd>
                    <dt>
                      事業計画の内容（金融商品取引契約の概要・企業情報・募集事項の内容等の17）
                    </dt>
                    <dd>{history.business_plan}</dd>
                    <dt>
                      発行者の財務状況（電子申込型電子募集取扱業務等に関する事項の3-2）
                    </dt>
                    <dd className="pre-scrollable">
                      {history.finance_condition != null
                        ? renderHTML(history.finance_condition)
                        : ''}
                    </dd>
                    <dt>
                      発行者の事業計画の妥当性（電子申込型電子募集取扱業務等に関する事項の3-3）
                    </dt>
                    <dd className="pre-scrollable">
                      {history.business_plan_validity != null
                        ? renderHTML(history.business_plan_validity)
                        : ''}
                    </dd>
                    <dt>
                      発行者の法令遵守状況を含めた適格性の3（電子申込型電子募集取扱業務等に関する事項の3-4-3）
                    </dt>
                    <dd>{history.company_eligibility}</dd>
                    <dt>
                      当社と発行者との利害関係の状況（電子申込型電子募集取扱業務等に関する事項の3-5）
                    </dt>
                    <dd className="pre-scrollable">
                      {history.stake != null ? renderHTML(history.stake) : ''}
                    </dd>
                    <dt>
                      事業継続体制及びコーポレートガバナンス体制（電子申込型電子募集取扱業務等に関する事項の3-6）
                    </dt>
                    <dd className="pre-scrollable">
                      {history.governance_system != null
                        ? renderHTML(history.governance_system)
                        : ''}
                    </dd>
                    <dt>別紙用の画像</dt>
                    <dd>
                      {history.contract_images.map(image => (
                        <div key={image.id}>
                          <img src={image.image_thumb_url} width={192} />
                        </div>
                      ))}
                    </dd>
                  </dl>
                </div>
              </div>
            )}
          </div>
        </div>

        <div className="row">
          <div className="col-md-6">
            <div className="box">
              <div className="box-header with-border">
                <h2 className="box-title">募集ページにおけるタブの内容</h2>
              </div>
              <div className="box-body">
                <dl>
                  <dt
                    className={
                      draft.description !== history.description
                        ? 'text-danger'
                        : ''
                    }
                  >
                    プロジェクトの詳細
                  </dt>
                  <dd className="pre-scrollable">
                    {draft.description != null
                      ? renderHTML(draft.description)
                      : ''}
                  </dd>
                  {draft.contract_before_type === 'PDF' && (
                    <dt
                      className={
                        draft.company_info !== history.company_info
                          ? 'text-danger'
                          : ''
                      }
                    >
                      企業情報
                    </dt>
                  )}
                  {draft.contract_before_type === 'PDF' && (
                    <dd className="pre-scrollable">
                      {draft.company_info != null
                        ? renderHTML(draft.company_info)
                        : ''}
                    </dd>
                  )}
                  {draft.contract_before_type === 'PDF' && (
                    <dt
                      className={
                        draft.solicit_info !== history.solicit_info
                          ? 'text-danger'
                          : ''
                      }
                    >
                      募集情報
                    </dt>
                  )}
                  {draft.contract_before_type === 'PDF' && (
                    <dd className="pre-scrollable">
                      {draft.solicit_info != null
                        ? renderHTML(draft.solicit_info)
                        : ''}
                    </dd>
                  )}
                  <dt
                    className={
                      draft.risk_info !== history.risk_info ? 'text-danger' : ''
                    }
                  >
                    企業のリスク等
                  </dt>
                  <dd className="pre-scrollable">
                    {draft.risk_info != null ? renderHTML(draft.risk_info) : ''}
                  </dd>
                  <dt
                    className={
                      draft.financial_info !== history.financial_info
                        ? 'text-danger'
                        : ''
                    }
                  >
                    事業計画
                  </dt>
                  <dd className="pre-scrollable">
                    {draft.financial_info != null
                      ? renderHTML(draft.financial_info)
                      : ''}
                  </dd>
                  {draft.contract_before_type === 'PDF' && (
                    <dt
                      className={
                        draft.review_result !== history.review_result
                          ? 'text-danger'
                          : ''
                      }
                    >
                      審査内容
                    </dt>
                  )}
                  {draft.contract_before_type === 'PDF' && (
                    <dd className="pre-scrollable">
                      {draft.review_result != null
                        ? renderHTML(draft.review_result)
                        : ''}
                    </dd>
                  )}
                </dl>
              </div>
            </div>
          </div>
          <div className="col-md-6">
            <div className="box">
              <div className="box-header with-border">
                <h2 className="box-title">募集ページにおけるタブの内容</h2>
              </div>
              <div className="box-body">
                <dl>
                  <dt>プロジェクトの詳細</dt>
                  <dd className="pre-scrollable">
                    {history.description != null
                      ? renderHTML(history.description)
                      : ''}
                  </dd>
                  {history.contract_before_type === 'PDF' && (
                    <dt>企業情報</dt>
                  )}
                  {history.contract_before_type === 'PDF' && (
                    <dd className="pre-scrollable">
                      {history.company_info != null
                        ? renderHTML(history.company_info)
                        : ''}
                    </dd>
                  )}
                  {history.contract_before_type === 'PDF' && <dt>募集情報</dt>}
                  {history.contract_before_type === 'PDF' && (
                    <dd className="pre-scrollable">
                      {history.solicit_info != null
                        ? renderHTML(history.solicit_info)
                        : ''}
                    </dd>
                  )}
                  <dt>企業のリスク等</dt>
                  <dd className="pre-scrollable">
                    {history.risk_info != null
                      ? renderHTML(history.risk_info)
                      : ''}
                  </dd>
                  <dt>事業計画</dt>
                  <dd className="pre-scrollable">
                    {history.financial_info != null
                      ? renderHTML(history.financial_info)
                      : ''}
                  </dd>
                  {history.contract_before_type === 'PDF' && <dt>審査内容</dt>}
                  {history.contract_before_type === 'PDF' && (
                    <dd className="pre-scrollable">
                      {history.review_result != null
                        ? renderHTML(history.review_result)
                        : ''}
                    </dd>
                  )}
                </dl>
              </div>
            </div>
          </div>
        </div>

        <div className="row">
          <div className="col-md-6">
            <div className="box">
              <div className="box-body no-padding">
                <table className="table">
                  <tbody>
                    <tr>
                      <td>状態</td>
                      <td>{draft.status}</td>
                    </tr>
                    <tr>
                      <td>作成者</td>
                      <td>{draft.admin}</td>
                    </tr>
                    <tr>
                      <td>承認者</td>
                      <td>{draft.authorizer}</td>
                    </tr>
                    <tr>
                      <td>更新日</td>
                      <td>{datetime(draft.updated_at)}</td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
          <div className="col-md-6">
            <div className="box">
              <div className="box-body no-padding">
                <table className="table">
                  <tbody>
                    <tr>
                      <td>状態</td>
                      <td>{history.status}</td>
                    </tr>
                    <tr>
                      <td>作成者</td>
                      <td>{history.admin}</td>
                    </tr>
                    <tr>
                      <td>承認者</td>
                      <td>{history.authorizer}</td>
                    </tr>
                    <tr>
                      <td>更新日</td>
                      <td>{datetime(history.updated_at)}</td>
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
