Rails.application.configure do
  config.serviceworker.routes.draw do
    match "/firebase-messaging-sw.js" => "push_notification/serviceworker.js"
    match "/manifest.json" => "push_notification/manifest.json"
  end
end
