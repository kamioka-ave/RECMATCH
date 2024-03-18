//= require jquery2
//= require jquery_ujs
//= require jquery.remotipart
//= require admin-lte/bootstrap/js/bootstrap
//= require admin-lte/dist/js/app.js
//= require bootstrap-growl/bootstrap-growl.min.js
//= require summernote
//= require summernote/locales/ja-JP
//= require ion-rangeslider/js/ion.rangeSlider.min.js
//= require moment/moment
//= require moment/locale/ja
//= require eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min
//= require codemirror/lib/codemirror
//= require codemirror/mode/xml/xml
//= require codemirror/mode/htmlmixed/htmlmixed
//= require_self
//= require react_ujs

window.React = require('react');
window.ReactDOM = require('react-dom');

window.views = {
  admin: {
    headlines: {
      FormView: require('./views/admin/headlines/FormView.js').default,
    },
    pages: {
      StudentCountChartView: require('./views/admin/pages/StudentCountChartView.js')
        .default,
      UserCountChartView: require('./views/admin/pages/UserCountChartView.js')
        .default,
      CompanyCountChartView: require('./views/admin/pages/CompanyCountChartView.js')
        .default,
      StudentHSChartView: require('./views/admin/pages/StudentHSChartView.js')
        .default,
      StudentGenderChartView: require('./views/admin/pages/StudentGenderChartView.js')
        .default,
      BarChartView: require('./views/admin/pages/BarChartView.js').default,
    },
    projects: {
      FormView: require('./views/admin/projects/FormView.js').default,
      NewView: require('./views/admin/projects/NewView.js').default,
      histories: {
        IndexView: require('./views/admin/projects/histories/IndexView.jsx')
          .default,
      },
    },
    sliders: {
      FormView: require('./views/admin/sliders/FormView.js').default,
    },
    companies: {
      NewCompanyView: require('./views/admin/companies/NewCompanyView.js')
        .default,
      EditCompanyView: require('./views/admin/companies/EditCompanyView.js')
        .default,
    },
    students: {
      SearchModal: require('./views/admin/students/SearchModal.jsx').default,
      histories: {
        IndexView: require('./views/admin/students/histories/IndexView.jsx')
          .default,
      },
    },
    users: {
      FormView: require('./views/admin/users/FormView.js').default,
    },
    question_drafts: {
      FormView: require('./views/admin/question_drafts/FormView.js').default,
    },
  },
};

/*
 * Flash Message
 */
window.notify = function notify(
  title,
  message,
  from,
  align,
  icon,
  type,
  animIn,
  animOut,
) {
  $.growl(
    {
      icon: icon,
      title: title,
      message: message,
      url: '',
    },
    {
      element: 'body',
      type: type,
      allow_dismiss: true,
      placement: {
        from: from,
        align: align,
      },
      offset: {
        x: 20,
        y: 85,
      },
      spacing: 10,
      z_index: 1031,
      delay: 2500,
      timer: 1000,
      url_target: '_blank',
      mouse_over: false,
      animate: {
        enter: animIn,
        exit: animOut,
      },
      icon_type: 'class',
      template:
        '<div data-growl="container" class="alert" role="alert">' +
        '<button type="button" class="close" data-growl="dismiss">' +
        '<span aria-hidden="true">&times;</span>' +
        '<span class="sr-only">Close</span>' +
        '</button>' +
        '<span data-growl="icon"></span>' +
        '<span data-growl="title"></span>' +
        '<span data-growl="message"></span>' +
        '<a href="#" data-growl="url"></a>' +
        '</div>',
    },
  );
};
