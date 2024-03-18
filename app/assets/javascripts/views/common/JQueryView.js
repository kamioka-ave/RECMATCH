// @flow
import $ from 'jquery';
import _ from 'lodash';

export function on(eventName: string) {
  return function(target: any, name: string, descriptor: any) {
    if (!target.events) {
      target.events = {};
    }

    target.events[eventName] = name;

    return descriptor;
  };
}

export default class JQueryView {
  $el: any;
  cid: string;
  events: any;

  constructor(el: string) {
    this.$el = $(el);
    this.cid = _.uniqueId('c');
    this.delegateEvents();
  }

  delegateEvents() {
    for (let key in this.events) {
      let method = this.events[key];

      if (!_.isFunction(method)) {
        // $FlowFixMe
        method = this[method];
      }

      if (!method) {
        continue;
      }

      const match = key.match(/^(\S+)\s*(.*)$/);

      // $FlowFixMe
      this.delegate(match[1], match[2], _.bind(method, this));
    }
  }

  delegate(eventName: any, selector: any, listener: any) {
    this.$el.on(eventName + '.delegateEvents' + this.cid, selector, listener);
  }
}
