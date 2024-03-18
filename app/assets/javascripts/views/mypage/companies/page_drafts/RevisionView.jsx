// @flow
import React from 'react';
import Slider from 'rc-slider';
import PageDraftClient from '../../../models/pages/PageDraftClient';

type Props = {
  draft: any,
  history: any,
  min: number,
  max: number,
  authenticityToken: string,
};

type State = {
  revision: number,
  history: any,
};

export default class RevisionView extends React.Component<Props, State> {
  pageDraftClient = new PageDraftClient();

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
    this.pageDraftClient
      .fetchHistory(this.props.draft.id, this.state.revision)
      .then(response => {
        this.setState({ history: response.data });
      })
      .catch(error => {
        alert(error);
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
                <h3>現在のコンテンツ</h3>
              </div>
              <div className="box-body">
                <dl>
                  <dt>タイトル</dt>
                  <dd>{draft.title}</dd>
                  <dt>パス</dt>
                  <dd>{draft.path}</dd>
                  <dt>メタデスクリプション（255文字以内）</dt>
                  <dd>{draft.description}</dd>
                  <dt>メタキーワード（カンマ区切り）</dt>
                  <dd>{draft.keywords}</dd>
                  <dt>本文</dt>
                  <dd>
                    <span dangerouslySetInnerHTML={{ __html: draft.body }} />
                  </dd>
                </dl>
              </div>
              <div className="box-footer no-padding">
                <table className="table">
                  <tbody>
                    <tr>
                      <td>状態</td>
                      <td>{draft.status}</td>
                    </tr>
                    <tr>
                      <td>更新日</td>
                      <td>{draft.updated_at}</td>
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
                  {revision}
                </h3>
              </div>
              <div className="box-body">
                <dl>
                  <dt>タイトル</dt>
                  <dd>{history.title}</dd>
                  <dt>パス</dt>
                  <dd>{history.path}</dd>
                  <dt>メタデスクリプション（255文字以内）</dt>
                  <dd>{history.description}</dd>
                  <dt>メタキーワード（カンマ区切り）</dt>
                  <dd>{history.keywords}</dd>
                  <dt>本文</dt>
                  <dd>
                    <span dangerouslySetInnerHTML={{ __html: history.body }} />
                  </dd>
                </dl>
              </div>
              <div className="box-footer no-padding">
                <table className="table">
                  <tbody>
                    <tr>
                      <td>状態</td>
                      <td>{history.status}</td>
                    </tr>
                    <tr>
                      <td>更新日</td>
                      <td>{history.updated_at}</td>
                    </tr>
                  </tbody>
                </table>
                <div className="p-10">
                  <form
                    action={`/recmatchadmin20180830/pages/${draft.id}/update_revision`}
                    acceptCharset="UTF-8"
                    method="post"
                  >
                    <input name="utf8" type="hidden" value="&#x2713;" />
                    <input type="hidden" name="_method" value="patch" />
                    <input
                      type="hidden"
                      name="authenticity_token"
                      value={this.props.authenticityToken}
                    />
                    <input type="hidden" name="revision" value={revision} />
                    <input
                      type="submit"
                      name="commit"
                      value="このリビジョンを使う"
                      className="btn btn-block btn-primary"
                      data-disable-with="このリビジョンを使う"
                    />
                  </form>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    );
  }
}
