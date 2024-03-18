Rails.application.routes.draw do
  resources :executed_projects
  devise_for :admins, path: 'recmatchadmin20180830', controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations',
  }

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    confirmations: 'users/confirmations',
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  mount ActionCable.server => '/cable'

  namespace :mypage do
    get '/' => 'pages#index', as: 'root'
    patch '/' => 'students#activate', as: 'activate_student'
    get '/company' => 'pages#company', as: 'company'
    get '/student' => 'pages#student', as: 'student'
    get '/events', to: 'pages#events'
    get '/projects', to: 'pages#projects'
    get '/account' => 'pages#account', as: 'account'
    get '/supporter' => 'supporters/companies#index'
    get '/staff' => 'staffs/group_chat_categories#index'
    resource :profile
    resources :summernotes
    resources :messages do
      member do
        delete 'trash'
        post 'untrash'
      end
      collection do
        delete 'trash'
      end
    end
    resource :company do
      resources :chat_messages, controller: 'companies/chat_messages'
      resources :search_students, controller: 'companies/search_students' do
        member do
          post 'favorite'
          post 'offer'
          delete 'cancel'
        end
        collection do
          get 'favorites'
        end
      end
      resources :applicants, controller: 'companies/applicants' do
        member do
          post 'finish'
          post 'new_make_date'
          post 'confirm_make_date'
          post 'change_make_date'
          post 'cancel'
          post 'meet_done'
          post 'approve'
        end
      end
      resources :event_applicants, controller: 'companies/event_applicants' do
        member do
          post 'finish'
          post 'wait'
        end
      end
      resource :agreement, controller: 'companies/agreements'
      resource :basic, controller: 'companies/basics'
      resource :detail, controller: 'companies/details'
      resources :reviews, controller: 'companies/reviews'
      resource :project_drafts, controller: 'companies/project_drafts'
      resources :event_drafts, controller: 'companies/event_drafts'

      resource :wizard do
        resource :agreement, controller: 'companies/wizard/agreements'
        resource :basic, controller: 'companies/wizard/basics'
        resource :detail, controller: 'companies/wizard/details'
        resource :confirm, controller: 'companies/wizard/confirms'
        resource :complete, controller: 'companies/wizard/completes'
        resource :page, controller: 'companies/wizard/pages', path: '/' do
          member do
            get 'thanks'
          end
        end
      end
      resource :eventorder do
        resource :page, controller: 'companies/eventorder/pages', path: '/' do
          member do
            get 'complete'
          end
        end
        resource :agreement, controller: 'companies/eventorder/agreements'
      end
      resource :new_company_page do
        resource :page, controller: 'companies/new_company_page/pages', path: '/' do
          member do
            get 'complete'
          end
        end
        resource :agreement, controller: 'companies/new_company_page/agreements'
      end
    end
    resource :student do
      resources :chat_messages, controller: 'students/chat_messages'
      member do
        get 'details'
        patch 'reconfirm'
      end
      resource :wizard do
        resource :agreement, controller: 'students/wizard/agreements'
        resource :student, controller: 'students/wizard/students' do
          member do
            get 'univfaculty'
            get 'univdepartment'
          end
        end
        resource :confirm, controller: 'students/wizard/confirms'
        resource :page, controller: 'students/wizard/pages', path: '/' do
          member do
            get 'thanks'
          end
        end
      end
      resource :reconfirm do
        resource :interview, controller: 'students/reconfirm/interviews'
        resource :student, controller: 'students/reconfirm/students'
        resource :pep, controller: 'students/reconfirm/peps'
        resource :confirm, controller: 'students/reconfirm/confirms'
      end
      resource :edit_wizard do
        resource :page, controller: 'students/edit_wizard/pages', path: '/'
        resource :student, controller: 'students/edit_wizard/students'
        resource :identification, controller: 'students/edit_wizard/identifications'
        resource :change_notification, controller: 'students/edit_wizard/change_notifications'
      end
      resources :order_reports, controller: 'students/order_reports'
      resources :change_notifications, controller: 'students/change_notifications'
      resources :applicants, controller: 'students/applicants'
      resources :project_applicants, controller: 'students/project_applicants' do
        member do
          post 'finish'
          post 'new_make_date'
          post 'change_make_date'
          post 'cancel'
          post 'approve'
        end
      end
    end

    resources :user_connections do
      collection do
        delete 'delete'
      end
    end
    resources :appointment
    resource :booking
    resource :leave
    resource :email
    resources :offers do
      member do
        post 'finish'
        post 'new_make_date'
        post 'confirm_make_date'
        post 'change_make_date'
        post 'cancel'
        post 'meet_done'
        post 'approve'
      end
    end
    resource :applicant
    resources :reports do
      member do
        get 'transaction_balance'
      end
    end
    resource :quit do
      member do
        post 'confirm'
      end
    end
  end

  namespace :admin, path: 'recmatchadmin20180830' do
    get '/' => 'pages#index', as: 'root'
    resources :page_drafts, path: '/pages' do
      member do
        get 'revision'
        patch 'update_revision'
      end
    end
    resources :events, controller: 'events' do
      member do
        patch 'approve'
        patch 'reject'
        get 'confirm'
        get 'preview'
      end
    end
    resources :users do
      collection do
        get 'download'
        get 'quits'
      end
      member do
        delete 'really_destroy'
      end
    end

    resources :headlines
    resources :project_drafts do
      member do
        patch 'approve'
        patch 'reject'
        get 'confirm'
        get 'preview'
      end
    end
    resources :projects do
      member do
        get 'applicants'
        put 'fail'
        put 'abort'
        put 'enable_front_display'
        put 'disable_front_display'
      end
      resources :histories, controller: 'projects/histories'
      resources :company_transaction_records, controller: 'projects/company_transaction_records'
      resources :headlines, controller: 'projects/headlines'
      resource :shareholder, controller: 'projects/shareholders' do
        member do
          get 'closed'
          get 'executed'
        end
      end
      resources :cancel_reasons, controller: 'projects/cancel_reasons'
    end
    resources :pickup_projects
    resources :sliders
    resources :executed_projects
    resource :breaking_project
    resources :categories
    resources :cancel_reason_questions
    resources :students do
      collection do
        get 'download'
      end
      resource :introduce, controller: 'students/introduces'
      member do
        get 'confirm'
        put 'approve'
        patch 'reject'
        get 'ledger'
        put 'change_mail_target'
        put 'enable_reapply'
        put 'disable_reapply'
      end
      resources :abilities, controller: 'students/abilities'
      resources :histories, controller: 'students/histories'
      resource :interview, controller: 'students/interviews' do
        member do
          get 'confirm'
          put 'approve'
          patch 'reject'
        end
      end
      resource :account, controller: 'students/accounts'
      resource :status, controller: 'students/statuses' do
        member do
          put 'approve'
          put 'reject'
          put 'reject_without_mail'
          put 'waiting_activation'
          put 'waiting_dm'
          get 'dm'
        end
      end
      resources :status_histories, controller: 'students/status_histories'
      resource :note, controller: 'students/notes'
      resource :lock, controller: 'students/locks'
      resource :unlock, controller: 'students/unlocks'
      resource :lock_reason, controller: 'students/lock_reasons'

      resources :transaction_records, controller: 'students/transaction_records'
      resource :change_history, controller: 'students/change_histories'
      resources :change_notifications, controller: 'students/change_notifications' do
        member do
          get 'dm'
          put 'sent_dm'
          put 'lock'
          get 'dm_locked'
          put 'sent_dm_locked'
          put 'confirm'
        end
      end
    end
    resource :students_display
    resources :student_lists do
      resources :emails, controller: 'student_lists/emails' do
        collection do
          post 'confirm'
        end
      end
    end
    resources :companies do
      member do
        put 'activate'
        put 'complete_primary_sales_support'
        put 'incomplete_primary_sales_support'
        put 'complete_all_sales_support'
        put 'incomplete_all_sales_support'
        put 'toggle'
      end

      resources :files, controller: 'companies/files'
      resource :account, controller: 'companies/accounts'
      resources :charges, controller: 'companies/charges'
      resources :status_histories, controller: 'companies/status_histories'
      resource :reject, controller: 'companies/rejects'
      resource :reject_reason, controller: 'companies/reject_reasons'
    end

    resources :admins
    resources :question_drafts
    resources :question_categories
    resources :reports do
      member do
        get 'transaction_balance'
      end
    end
    resource :pages, only: [:index], path: '/' do
      collection do
        get 'user_aggregates'
        get 'student_aggregates'
        get 'company_aggregates'
        get 'access_denied'
      end
    end
    namespace :transactions do
      resources :students, controller: 'students'
      resources :companies, controller: 'companies'
    end
  end

  namespace :api do
    namespace :v1 do
      resources :summernotes
      resources :banks
      resources :bank_branches
      resources :group_chats do
        member do
          post :send_message
          put :mark_all_as_read
          get :messages
          get :attachments
        end
      end
      resources :messages, only: :show
      resources :jnb_transfers

      unless Rails.env.production?
        resources :stock_histories, only: :index
      end
      resources :user_tokens
      resources :members do
        member do
          get :unread_messages
        end
        resources :notifications, only: :index
      end
      resources :ses_notifications

      if Rails.env.staging?
        resources :projects
      end
    end
  end

  resource :contact
  #resources :questions do
  #  collection do
  #    get 'search'
  #  end
  #  member do
  #    get 'category'
  #    put 'upvote'
  #    put 'downvote'
  #  end
  #end

  resources :headlines do
    collection do
      get 'feed'
    end
  end
  resources :events
  resources :event_applicants, controller: 'events/applicants' do
    member do
      post 'submit'
      get 'reached'
      get 'notice'
   end
  end
  resources :project_applicants, controller: 'projects/applicants' do
    member do
      post 'submit'
      get 'reached'
      get 'notice'
   end
  end
  resources :projects do
    collection do
      get 'hot'
      get 'feed'
    end
    member do
      get 'parts'
      get 'reached'
      get 'notice'
    end
    resources :headlines, controller: 'projects/headlines'
    resources :applicants, controller: 'projects/applicants'
  end
  resource :delivery_stop
  resource :quit do
    member do
      post 'confirm'
    end
  end
  resources :profiles
  resources :public_messages

  root 'pages#index'
  match '/preview_page' => 'pages#preview', via: [:get, :post], as: 'preview'
  resources :pages, path: '/' do
    collection do
      get 'thanks'
      get 'health'
      get 'new_company_page'
      get 'eventorder'
      get 'quit'
      get 'about'
      #get 'about_company'
      get 'completion_quit'
      get 'kiyaku'
      get 'disclosure'
      get 'privacy_policy'
      get 'cancel_complete'
    end
  end

end
