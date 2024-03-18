// @flow
import React from 'react';
import { Button, FormControl, FormGroup, InputGroup } from 'react-bootstrap';
import type { Condition } from '../../../models/ransack/Condition';

type Props = {
  id: number,
  attribute: ?string,
  predicate: ?string,
  value: ?string,
  attributes: any,
  predicates: any,
  namesWithStudentStatus: any,
  namesWithOrderStatus: any,
  namesWithStudentIsMailTarget: any,
  namesWithEnableReapply: any,
  onChange: (condition: Condition) => void,
  onRemove: (id: number) => void,
};

type State = Condition & {};

declare var $: any;

export default class SearchField extends React.Component<Props, State> {
  constructor(props: Props) {
    super(props);

    this.state = {
      id: props.id,
      attribute: props.attribute,
      predicate: props.predicate,
      value: props.value,
    };
  }

  renderValue() {
    const {
      id,
      namesWithStudentStatus,
      namesWithOrderStatus,
      namesWithStudentIsMailTarget,
      namesWithEnableReapply,
    } = this.props;
    const { attribute, value } = this.state;

    if (attribute === 'status') {
      return (
        <FormControl
          name={`q[c][${id}][v][0][value]`}
          componentClass="select"
          placeholder="select"
          value={value || ''}
          onChange={e => {
            this.setState({ value: e.target.value }, () =>
              this.props.onChange(this.state),
            );
          }}
        >
          <option value="" />
          {Object.keys(namesWithStudentStatus).map((name, i) => (
            <option key={i} value={namesWithStudentStatus[name]}>
              {name}
            </option>
          ))}
        </FormControl>
      );
    }
    if (attribute === 'orders_status') {
      return (
        <FormControl
          name={`q[c][${id}][v][0][value]`}
          componentClass="select"
          placeholder="select"
          value={value || ''}
          onChange={e => {
            this.setState({ value: e.target.value }, () =>
              this.props.onChange(this.state),
            );
          }}
        >
          <option value="" />
          {Object.keys(namesWithOrderStatus).map((name, i) => (
            <option key={i} value={namesWithOrderStatus[name]}>
              {name}
            </option>
          ))}
        </FormControl>
      );
    }
    if (attribute === 'is_mail_target') {
      return (
        <FormControl
          name={`q[c][${id}][v][0][value]`}
          componentClass="select"
          placeholder="select"
          value={value || ''}
          onChange={e => {
            this.setState({ value: e.target.value }, () =>
              this.props.onChange(this.state),
            );
          }}
        >
          <option value="" />
          {Object.keys(namesWithStudentIsMailTarget).map((name, i) => (
            <option key={i} value={namesWithStudentIsMailTarget[name]}>
              {name}
            </option>
          ))}
        </FormControl>
      );
    }
    if (attribute === 'enable_reapply') {
      return (
        <FormControl
          name={`q[c][${id}][v][0][value]`}
          componentClass="select"
          placeholder="select"
          value={value || ''}
          onChange={e => {
            this.setState({ value: e.target.value }, () =>
              this.props.onChange(this.state),
            );
          }}
        >
          <option value="" />
          {Object.keys(namesWithEnableReapply).map((name, i) => (
            <option key={i} value={namesWithEnableReapply[name]}>
              {name}
            </option>
          ))}
        </FormControl>
      );
    } else if (
      attribute === 'created_at' ||
      attribute === 'rejected_at' ||
      attribute === 'applied_at' ||
      attribute === 'locked_at' ||
      attribute === 'approved_at' ||
      attribute === 'waiting_activation_at' ||
      attribute === 'activated_at' ||
      attribute === 'orders_order_at' ||
      attribute === 'orders_canceled_at'
    ) {
      setTimeout(() => {
        $('.datetime')
          .datetimepicker({
            locale: 'ja',
            format: 'YYYYMMDD HH:mm',
            sideBySide: true,
          })
          .on('dp.change', e => {
            console.log('datetime', e);
            if (e.date) {
              this.setState({ value: e.date.format('YYYYMMDD HH:mm') }, () =>
                this.props.onChange(this.state),
              );
            }
          });
      }, 100);

      return (
        <FormGroup>
          <InputGroup className="datetime">
            <FormControl
              name={`q[c][${id}][v][0][value]`}
              type="text"
              value={value || ''}
              onChange={e => {
                this.setState({ value: e.target.value }, () =>
                  this.props.onChange(this.state),
                );
              }}
            />
            <InputGroup.Addon>
              <span className="glyphicon glyphicon-calendar" />
            </InputGroup.Addon>
          </InputGroup>
        </FormGroup>
      );
    } else {
      return (
        <FormControl
          name={`q[c][${id}][v][0][value]`}
          type="text"
          value={value || ''}
          onChange={e => {
            this.setState({ value: e.target.value }, () =>
              this.props.onChange(this.state),
            );
          }}
        />
      );
    }
  }

  render() {
    const { id, attributes, predicates } = this.props;
    const { attribute, predicate } = this.state;

    return (
      <fieldset className="mb-10">
        <div className="row">
          <div className="col-md-3">
            <FormControl
              name={`q[c][${id}][a][0][name]`}
              componentClass="select"
              placeholder="select"
              value={attribute || ''}
              onChange={e => {
                this.setState(
                  {
                    attribute: e.target.value,
                    value: '',
                  },
                  () => this.props.onChange(this.state),
                );
              }}
            >
              <option value="" />
              {Object.keys(attributes).map((e, i) => (
                <option key={i} value={e}>
                  {attributes[e]}
                </option>
              ))}
            </FormControl>
          </div>
          <div className="col-md-3">
            <FormControl
              name={`q[c][${id}][p]`}
              componentClass="select"
              placeholder="select"
              value={predicate || ''}
              onChange={e => {
                this.setState({ predicate: e.target.value }, () =>
                  this.props.onChange(this.state),
                );
              }}
            >
              <option value="" />
              {Object.keys(predicates).map((p, i) => (
                <option key={i} value={p}>
                  {predicates[p]}
                </option>
              ))}
            </FormControl>
          </div>
          <div className="col-md-4">{this.renderValue()}</div>
          <div className="col-md-2">
            <Button bsSize="small" onClick={() => this.props.onRemove(id)}>
              <i className="fa fa-minus-circle" /> 削除
            </Button>
          </div>
        </div>
      </fieldset>
    );
  }
}
