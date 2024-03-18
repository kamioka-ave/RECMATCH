import _ from 'lodash';

export function on(eventName) {
  return function(target, name, descriptor) {
    if (!target.events) {
      target.events = {};
    }

    if (_.isFunction(target.events)) {
      throw new Error('The on decorator is not compatible with an events method');
    }

    if (!eventName) {
      throw new Error('The on decorator requires an eventName argument');
    }

    target.events[eventName] = name;

    return descriptor;
  };
}
