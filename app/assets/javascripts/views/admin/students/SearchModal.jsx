// @flow
import React from 'react';
import { Button, Modal } from 'react-bootstrap';
import SearchField from './SearchField.jsx';
import type { Condition } from '../../../models/ransack/Condition';

type Props = {
  conditions: Array<Condition>,
  attributes: any,
  predicates: any,
  namesWithStudentStatus: any,
  namesWithOrderStatus: any,
  namesWithStudentIsMailTarget: any,
  namesWithEnableReapply: any,
};

type State = {
  visible: boolean,
  conditions: Array<Condition>,
};

export default class SearchModal extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);

    this.state = {
      visible: false,
      conditions: props.conditions,
    };
  }

  canSubmit() {
    const { conditions } = this.state;
    const invalidConditions = conditions.filter(c => {
      return (
        c.attribute == null ||
        c.attribute === '' ||
        c.predicate == null ||
        c.predicate === '' ||
        c.value == null ||
        c.value === ''
      );
    });

    return invalidConditions.length === 0;
  }

  onAddField() {
    const { conditions } = this.state;
    const nextID = conditions[conditions.length - 1].id + 1;

    this.setState({
      conditions: [
        ...this.state.conditions,
        {
          id: nextID,
          attribute: null,
          predicate: null,
          value: null,
        },
      ],
    });
  }

  onRemoveField(id: number) {
    this.setState({
      conditions: [...this.state.conditions.filter(c => c.id !== id)],
    });
  }

  onChangeCondition(condition: Condition) {
    this.setState({
      conditions: [
        ...this.state.conditions.filter(c => c.id !== condition.id),
        condition,
      ],
    });
  }

  render() {
    const { visible, conditions } = this.state;

    return (
      <span>
        <a
          href="#"
          className="text-muted"
          onClick={() => this.setState({ visible: true })}
        >
          <i className="fa fa-search" />
        </a>
        <Modal
          show={visible}
          bsSize="large"
          onHide={() => this.setState({ visible: false })}
        >
          <form
            action="/recmatchadmin20180830/students"
            acceptCharset="UTF-8"
            method="get"
          >
            <input name="utf8" type="hidden" value="&#x2713;" />
            <Modal.Header closeButton>
              <Modal.Title>絞り込み</Modal.Title>
            </Modal.Header>
            <Modal.Body>
              {conditions.map(c => (
                <SearchField
                  key={c.id}
                  id={c.id}
                  attribute={c.attribute}
                  predicate={c.predicate}
                  value={c.value}
                  attributes={this.props.attributes}
                  predicates={this.props.predicates}
                  namesWithStudentStatus={this.props.namesWithStudentStatus}
                  namesWithOrderStatus={this.props.namesWithOrderStatus}
                  namesWithStudentIsMailTarget={
                    this.props.namesWithStudentIsMailTarget
                  }
                  namesWithEnableReapply={this.props.namesWithEnableReapply}
                  onChange={condition => this.onChangeCondition(condition)}
                  onRemove={id => this.onRemoveField(id)}
                />
              ))}
              <Button bsSize="small" onClick={() => this.onAddField()}>
                <i className="fa fa-plus-circle" /> 追加
              </Button>
            </Modal.Body>
            <Modal.Footer>
              <Button
                type="submit"
                bsStyle="primary"
                disabled={!this.canSubmit()}
              >
                適用
              </Button>
            </Modal.Footer>
          </form>
        </Modal>
      </span>
    );
  }
}
