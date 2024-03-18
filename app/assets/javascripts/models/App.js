// @flow
declare var ActionCable: any;

class App {
  cable = ActionCable.createConsumer();
  //
  // // $FlowFixMe
  // get cable(): any {
  //   return this.cable;
  // }
  //
}

export default new App();