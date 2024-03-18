//= require jquery3
//= require jquery_ujs
//= require jquery.remotipart
//= require jquery.cookie/jquery.cookie
//= require bootstrap-sprockets
//= require bootstrap-growl/bootstrap-growl.min.js
//= require readmore-js/readmore
//= require moment/moment
//= require moment/locale/ja
//= require fullcalendar
//= require eonasdan-bootstrap-datetimepicker/build/js/bootstrap-datetimepicker.min
//= require swiper/dist/js/swiper.jquery
//= require action_cable
//= require summernote
//= require summernote/locales/ja-JP
//= require jquery.jpostal.js
//= require turbolinks
//= require_self
//= require react_ujs
//= require push_notification
//= require calendar.js
//= require cable.js

require('babel-polyfill');

window.React = require('react');
window.ReactDOM = require('react-dom');

window.views = {
  layouts: {
    AppView: require('./views/layouts/AppView.js').default,
    SlidebarView: require('./views/layouts/SlidebarView.js').default,
  },
  mypage: {
    profiles: {
      FormView: require('./views/mypage/profiles/FormView.js').default,
    },
    companies: {
      basics: {
        FormView: require('./views/mypage/companies/basics/FormView.js').default,
      },
      chart: {
        GenderChartView: require('./views/mypage/companies/chart/GenderChartView.js')
          .default,
        HiredGenderChartView: require('./views/mypage/companies/chart/HiredGenderChartView.js')
          .default,
        RetireChartView: require('./views/mypage/companies/chart/RetireChartView.js')
          .default,
        SearchChartView: require('./views/mypage/companies/chart/SearchChartView.js')
          .default,
        DetailSearchChartView: require('./views/mypage/companies/chart/DetailSearchChartView.js')
          .default,
      },
      events: {
        FormView: require('./views/mypage/companies/events/FormView.js').default,
      },
      details: {
        FormView: require('./views/mypage/companies/details/FormView.js').default,
      },
      projects: {
        FormView: require('./views/mypage/companies/projects/FormView.js').default,
        NewView: require('./views/mypage/companies/projects/NewView.js').default,
      },
      histories: {
          IndexView: require('./views/mypage/companies/projects/histories/IndexView.jsx').default,
      },
      newcompanypage: {
        agreements: {
          FormView: require('./views/mypage/companies/newcompanypage/agreements/FormView.js')
            .default,
        },
      },
      wizard: {
        confirms: {
          ShowView: require('./views/mypage/companies/wizard/confirms/ShowView.js')
            .default,
        },
      },
    },
    students: {
      FormView: require('./views/mypage/students/FormView.js').default,
    },
    quits: {
      FormView: require('./views/mypage/quits/FormView.js').default,
    },
    pages: {
      StudentEstimatedAssetPieChartView: require('./views/mypage/pages/StudentEstimatedAssetPieChartView.js')
        .default,
      StudentEstimatedAssetLineChartView: require('./views/mypage/pages/StudentEstimatedAssetLineChartView.js')
        .default,
      AssetsStatView: require('./views/mypage/pages/AssetsStatView.js').default,
    },
    cancel_reasons: {
      FormView: require('./views/mypage/orders/cancel_reasons/FormView.js').default,
    },
  },
  companies: {
    GraphView: require('./views/companies/GraphView.js').default,
  },
  projects: {
    ShowView: require('./views/projects/ShowView.js').default,
  },
  users: {
    registrations: {
      FormView: require('./views/users/registrations/FormView').default,
    },
  },
  pages: {
    SliderView: require('./views/pages/SliderView').default,
    NewcompanypageView: require('./views/pages/NewcompanypageView').default,
    BarChartView: require('./views/pages/BarChartView').default,
    StudentAgeChartView: require('./views/pages/StudentAgeChartView').default,
    StudentAssetsChartView: require('./views/pages/StudentAssetsChartView')
      .default,
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

//ahoy.trackAll();
