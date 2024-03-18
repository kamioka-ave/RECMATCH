# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_05_10_163656) do

  create_table "accounts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.integer "balance", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_accounts_on_deleted_at"
  end

  create_table "admin_companies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "admin_id"
    t.integer "company_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admin_roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_admin_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_admin_roles_on_name"
  end

  create_table "admin_students_displays", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "admin_id"
    t.boolean "identifier", default: true, null: false
    t.boolean "full_name", default: true, null: false
    t.boolean "birth_on", default: true, null: false
    t.boolean "birth_on_ja", default: true, null: false
    t.boolean "status", default: true, null: false
    t.boolean "student_created_at", default: false, null: false
    t.boolean "applied_at", default: false, null: false
    t.boolean "approved_at", default: false, null: false
    t.boolean "rejected_at", default: false, null: false
    t.boolean "waiting_activation_at", default: false, null: false
    t.boolean "activated_at", default: false, null: false
    t.boolean "created_days", default: true, null: false
    t.boolean "applied_days", default: true, null: false
    t.boolean "locked_at", default: true, null: false
    t.boolean "lock_reason", default: true, null: false
    t.boolean "total_order_price", default: false, null: false
    t.boolean "total_investment_price", default: false, null: false
    t.boolean "investment_history", default: false, null: false
    t.boolean "current_sign_in_at", default: false, null: false
    t.boolean "lost_orders", default: true, null: false
    t.boolean "identification_note", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "admins_admin_roles", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "admin_id"
    t.integer "admin_role_id"
    t.index ["admin_id", "admin_role_id"], name: "index_admins_admin_roles_on_admin_id_and_admin_role_id"
  end

  create_table "aggregations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "type"
    t.date "date"
    t.integer "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type", "date"], name: "index_aggregations_on_type_and_date", unique: true
  end

  create_table "ahoy_events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "visit_id"
    t.integer "user_id"
    t.string "name"
    t.text "properties"
    t.timestamp "time"
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["user_id", "name"], name: "index_ahoy_events_on_user_id_and_name"
    t.index ["visit_id", "name"], name: "index_ahoy_events_on_visit_id_and_name"
  end

  create_table "bank_branches", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "bank_id"
    t.integer "code"
    t.string "name"
    t.string "kana"
    t.string "hiragana"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "banks", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.string "kana"
    t.string "hiragana"
    t.boolean "is_popular", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chat_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_id"
    t.integer "student_id"
    t.boolean "direct"
    t.boolean "kidoku", default: false, null: false
    t.text "description"
    t.string "files"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "chat_questions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.text "question"
    t.text "answer"
    t.integer "question_id"
    t.string "facebook_id"
    t.string "line_id"
    t.string "conversation_id"
    t.string "dialog_node"
    t.integer "dialog_turn_counter"
    t.integer "dialog_request_counter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "title", limit: 50, default: ""
    t.text "comment"
    t.string "commentable_type"
    t.integer "commentable_id"
    t.integer "user_id"
    t.string "role", default: "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "cached_votes_up", default: 0
    t.integer "status", default: 0, null: false
    t.index ["commentable_id"], name: "index_comments_on_commentable_id"
    t.index ["commentable_type"], name: "index_comments_on_commentable_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "companies", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.integer "creator_id"
    t.integer "issuer_id"
    t.integer "business_type_id"
    t.string "name"
    t.string "name_kana"
    t.string "president_first_name"
    t.string "president_first_name_kana"
    t.string "president_last_name"
    t.string "president_last_name_kana"
    t.date "president_birth_on"
    t.string "zip_code"
    t.integer "prefecture_id"
    t.string "city"
    t.string "address1"
    t.string "address2"
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "market_cap"
    t.integer "stage"
    t.bigint "capital"
    t.bigint "sales_profit"
    t.date "birth_on"
    t.date "accounting_started_on"
    t.date "accounting_finished_on"
    t.string "website"
    t.string "image"
    t.integer "draft_id"
    t.timestamp "published_at"
    t.timestamp "trashed_at"
    t.string "image_draft"
    t.string "reviews_zip"
    t.string "angels_zip"
    t.text "business_summary"
    t.text "business_philosophy"
    t.text "hope"
    t.text "business_shebang"
    t.text "main_shareholders"
    t.text "financing"
    t.text "introduce_something"
    t.integer "status"
    t.text "reject_reason"
    t.integer "employees"
    t.integer "this_year_employments"
    t.integer "last_year_employments"
    t.boolean "this_year_employments_reveal"
    t.boolean "last_year_employments_reveal"
    t.text "competitive_strength"
    t.text "competitive_difference"
    t.text "target"
    t.text "ceo_hopes"
    t.datetime "applied_at"
    t.boolean "is_identification_passed"
    t.datetime "identified_at"
    t.integer "identifier_id"
    t.boolean "is_antisocial_check_passed"
    t.datetime "antisocial_checked_at"
    t.integer "antisocial_checker_id"
    t.integer "approver_id"
    t.boolean "agree_with_clause"
    t.boolean "agree_with_pre_judge"
    t.datetime "agree_with_pre_judge_at"
    t.integer "company_supporter_messages_count", default: 0
    t.boolean "primary_sales_support_completed"
    t.boolean "all_sales_support_completed"
    t.integer "followers_count"
    t.integer "chat_toggle"
    t.boolean "agree_use_group_chat"
  end

  create_table "company_agreements", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.integer "company_id"
    t.boolean "pdf1", default: false, null: false
    t.boolean "pdf2", default: false, null: false
    t.boolean "pdf3", default: false, null: false
    t.boolean "pdf4", default: false, null: false
    t.boolean "agreement", default: false, null: false
    t.boolean "terms10_agreed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_company_agreements_on_deleted_at"
  end

  create_table "company_business_types", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_document_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "type"
    t.integer "document_type"
    t.integer "company_id"
    t.integer "admin_id"
    t.string "name"
    t.text "file"
    t.text "description"
    t.text "comment"
    t.integer "authorizer_id"
    t.integer "status", default: 0, null: false
    t.string "change"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_documents", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "type", default: "Company::OtherDocument"
    t.integer "document_type"
    t.integer "company_id"
    t.integer "admin_id"
    t.string "name"
    t.string "file"
    t.text "description"
    t.text "comment"
    t.integer "authorizer_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_fares", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_id"
    t.integer "admin_id"
    t.integer "priority_no"
    t.integer "subject"
    t.string "subject_note"
    t.date "start_at"
    t.date "end_at"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_followers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_id"
    t.integer "user_id"
    t.integer "student_id"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_followers_emails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_id"
    t.integer "admin_id"
    t.integer "job_id"
    t.string "subject"
    t.text "plain"
    t.text "rich"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_graph_data", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_graph_id"
    t.string "label"
    t.integer "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_graphs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_id"
    t.string "name"
    t.integer "rank"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_review_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_review_id"
    t.integer "company_id"
    t.integer "admin_id"
    t.integer "review_type"
    t.string "file"
    t.text "comment"
    t.integer "authorizer_id"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "operation", default: 0, null: false
  end

  create_table "company_reviews", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_id"
    t.integer "admin_id"
    t.integer "review_type"
    t.string "file"
    t.text "comment"
    t.integer "authorizer_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_status_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_id"
    t.integer "updater_id"
    t.integer "status"
    t.boolean "is_identification_passed"
    t.boolean "is_antisocial_check_passed"
    t.text "reject_reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "company_supporter_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_supporter_id"
    t.integer "sender_id"
    t.string "sender_type"
    t.integer "receiver_id"
    t.string "receiver_type"
    t.text "body"
    t.string "attachment"
    t.boolean "read", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "group_chat_id"
    t.index ["group_chat_id"], name: "index_company_supporter_messages_on_group_chat_id"
  end

  create_table "company_supporters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_id"
    t.integer "supporter_id"
    t.integer "company_supporter_messages_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id", "supporter_id"], name: "index_company_supporters_on_company_id_and_supporter_id", unique: true
  end

  create_table "consultations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "supporter_id"
    t.integer "company_id"
    t.bigint "group_chat_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.bigint "group_chat_id"
    t.index ["deleted_at"], name: "index_consultations_on_deleted_at"
    t.index ["group_chat_category_id"], name: "index_consultations_on_group_chat_category_id"
    t.index ["group_chat_id"], name: "index_consultations_on_group_chat_id"
    t.index ["supporter_id"], name: "index_consultations_on_supporter_id"
  end

  create_table "contacts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.string "email"
    t.text "message"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.string "name_en"
    t.string "code"
    t.string "code_ja"
    t.string "code_string2"
    t.string "code_string3"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "event_agreements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_id"
    t.boolean "agree_with_clause", default: false, null: false
    t.boolean "agree_with_pre_judge", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_applicants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "event_id"
    t.integer "student_id"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "remind_event_student_job_id"
  end

  create_table "events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_id"
    t.integer "proposal_id"
    t.string "title"
    t.string "name"
    t.string "image"
    t.integer "event_type"
    t.datetime "start"
    t.datetime "end"
    t.text "description", limit: 16777215
    t.integer "capacity"
    t.integer "prefecture_id"
    t.string "address"
    t.integer "status"
    t.boolean "selection"
    t.integer "revision", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "finish_job_id"
  end

  create_table "favorites", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_id"
    t.integer "student_id"
    t.integer "direction"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "follows", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "followable_type", null: false
    t.integer "followable_id", null: false
    t.string "follower_type", null: false
    t.integer "follower_id", null: false
    t.boolean "blocked", default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["followable_id", "followable_type"], name: "fk_followables"
    t.index ["follower_id", "follower_type"], name: "fk_follows"
  end

  create_table "group_chat_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 1
    t.integer "ranking"
  end

  create_table "group_chat_category_supporters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "group_chat_category_id"
    t.bigint "supporter_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_group_chat_category_supporters_on_deleted_at"
    t.index ["group_chat_category_id"], name: "index_group_chat_category_supporters_on_group_chat_category_id"
    t.index ["supporter_id"], name: "index_group_chat_category_supporters_on_supporter_id"
  end

  create_table "group_chat_members", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "member_type"
    t.bigint "member_id"
    t.bigint "group_chat_id"
    t.timestamp "last_read"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "unread_notification_last_sent"
    t.datetime "last_read_notification"
    t.index ["group_chat_id"], name: "index_group_chat_members_on_group_chat_id"
    t.index ["member_type", "member_id"], name: "index_group_chat_members_on_member_type_and_member_id"
  end

  create_table "group_chats", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "group_chat_category_id"
    t.integer "message_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_chat_category_id"], name: "index_group_chats_on_group_chat_category_id"
  end

  create_table "headlines", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "headline_type", default: 0, null: false
    t.string "title"
    t.text "body"
    t.integer "status", default: 0
    t.datetime "published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "impressions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "params"
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", length: { params: 100 }
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: { message: 255 }
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "inflow_params", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "inflow_id"
    t.string "name"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inflows", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.string "ab"
    t.text "referer"
    t.integer "segment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "jobs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "project_id"
    t.string "title"
    t.text "description"
    t.integer "job_type"
    t.date "close_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailboxer_conversation_opt_outs", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "unsubscriber_type"
    t.integer "unsubscriber_id"
    t.integer "conversation_id"
    t.index ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id"
    t.index ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type"
  end

  create_table "mailboxer_conversations", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "subject", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mailboxer_notifications", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "type"
    t.text "body"
    t.string "subject", default: ""
    t.string "sender_type"
    t.integer "sender_id"
    t.integer "conversation_id"
    t.boolean "draft", default: false
    t.string "notification_code"
    t.string "notified_object_type"
    t.integer "notified_object_id"
    t.string "attachment"
    t.datetime "updated_at", null: false
    t.datetime "created_at", null: false
    t.boolean "global", default: false
    t.datetime "expires"
    t.index ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id"
    t.index ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type"
    t.index ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type"
    t.index ["type"], name: "index_mailboxer_notifications_on_type"
  end

  create_table "mailboxer_receipts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "receiver_type"
    t.integer "receiver_id"
    t.integer "notification_id", null: false
    t.boolean "is_read", default: false
    t.boolean "trashed", default: false
    t.boolean "deleted", default: false
    t.string "mailbox_type", limit: 25
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_delivered", default: false
    t.string "delivery_method"
    t.string "message_id"
    t.index ["notification_id"], name: "index_mailboxer_receipts_on_notification_id"
    t.index ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type"
  end

  create_table "marketing_reports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.date "date", null: false
    t.integer "user_increase", default: 0, null: false
    t.integer "student_increase", default: 0, null: false
    t.integer "student_new_increase", default: 0, null: false
    t.integer "student_in_review_increase", default: 0, null: false
    t.integer "student_activated_increase", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_marketing_reports_on_date", unique: true
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "userid"
    t.integer "company_id"
    t.integer "student_id"
    t.datetime "sent_at"
    t.text "subject"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "offers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "company_id"
    t.integer "student_id"
    t.integer "project_id"
    t.integer "event_id"
    t.integer "offer_type"
    t.integer "status", default: 0, null: false
    t.text "description"
    t.date "closing_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "order_invoices", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "order_id"
    t.date "date"
    t.string "name"
    t.string "name_kana"
    t.string "kana"
    t.date "payment_due_at"
    t.integer "total_due"
    t.string "bank_name"
    t.string "bank_branch_code"
    t.string "bank_branch_name"
    t.string "bank_account_type"
    t.integer "bank_account_number"
    t.string "bank_account_name"
    t.string "bank_account_name_kana"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "orders", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "user_id"
    t.integer "student_id"
    t.integer "project_id"
    t.integer "payment_method"
    t.datetime "contact_date"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "price"
    t.integer "unit_price"
    t.boolean "contract_confirmed", default: false, null: false
    t.datetime "payment_at"
  end

  create_table "page_drafts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "admin_id"
    t.string "path"
    t.integer "page_type", default: 0, null: false
    t.string "title"
    t.text "head"
    t.text "body", limit: 16777215
    t.string "description"
    t.string "keywords"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pages", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "page_draft_id"
    t.string "path"
    t.integer "page_type", default: 0, null: false
    t.string "title"
    t.text "head"
    t.text "body", limit: 16777215
    t.string "description"
    t.string "keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pickup_projects", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "project_id"
    t.integer "rank", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profiles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "description"
    t.string "image"
    t.string "name_kana"
    t.string "company"
    t.string "tel"
    t.integer "gender", default: 0, null: false
    t.string "zip_code"
    t.string "identification"
    t.text "identification_note"
    t.boolean "identified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.boolean "is_leave", default: false, null: false
    t.boolean "receive_notification", default: true, null: false
    t.boolean "use_social", default: false, null: false
    t.index ["deleted_at"], name: "index_profiles_on_deleted_at"
  end

  create_table "project_applicants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "project_id"
    t.integer "student_id"
    t.integer "status", default: 0, null: false
    t.datetime "start"
    t.datetime "end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "project_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_company_presidents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "projectable_id"
    t.string "projectable_type"
    t.string "position"
    t.string "first_name"
    t.string "first_name_kana"
    t.string "last_name"
    t.string "last_name_kana"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["projectable_id", "projectable_type"], name: "index_project_company_presidents_on_id_and_type"
  end

  create_table "project_contract_images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "projectable_id"
    t.string "projectable_type"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["projectable_id", "projectable_type"], name: "index_project_contract_images_on_id_and_type"
  end

  create_table "project_corrected_documents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "project_id"
    t.string "name"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_draft_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "project_draft_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_drafts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "proposal_id"
    t.integer "company_id"
    t.string "name"
    t.string "image"
    t.string "interview_movie"
    t.integer "status", default: 0, null: false
    t.string "president_image"
    t.text "president_description"
    t.string "short_description"
    t.text "description", limit: 16777215
    t.text "company_info", limit: 16777215
    t.integer "number_hired"
    t.integer "revision", default: 1, null: false
    t.text "salary"
    t.text "process_selection"
    t.text "selection_condition"
    t.date "entry_closed"
    t.text "student_assumption"
    t.text "recruit_kind"
    t.text "duty_station"
    t.text "new_salary"
    t.text "allowance"
    t.text "raise_salary"
    t.text "reward"
    t.text "holiday"
    t.text "insurance"
    t.text "welfare_program"
    t.text "company_event"
    t.integer "sex_ratio"
    t.text "trial_period"
    t.text "other_welfare"
    t.integer "retired_ratio"
    t.integer "sex_ratio_hired"
    t.integer "continuous"
    t.integer "old"
    t.text "training"
    t.text "vacation"
    t.text "childcare"
    t.text "recruit_univ"
    t.text "univ_depart"
    t.date "start_at"
    t.date "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "shareholder_meeting_on"
    t.date "board_meeting_on"
  end

  create_table "project_headlines", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "project_id"
    t.integer "user_id"
    t.integer "admin_id"
    t.string "name"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "proposal_id"
    t.integer "company_id"
    t.integer "project_draft_id"
    t.string "name"
    t.string "image"
    t.string "interview_movie"
    t.integer "status", default: 0, null: false
    t.string "president_image"
    t.text "president_description"
    t.string "short_description"
    t.text "description", limit: 16777215
    t.text "company_info", limit: 16777215
    t.integer "number_hired"
    t.integer "revision"
    t.text "salary"
    t.text "process_selection"
    t.text "selection_condition"
    t.date "entry_closed"
    t.text "student_assumption"
    t.text "recruit_kind"
    t.text "duty_station"
    t.integer "new_salary"
    t.text "allowance"
    t.text "raise_salary"
    t.text "reward"
    t.text "holiday"
    t.text "insurance"
    t.text "welfare_program"
    t.text "company_event"
    t.integer "sex_ratio"
    t.text "trial_period"
    t.text "other_welfare"
    t.integer "retired_ratio"
    t.integer "sex_ratio_hired"
    t.integer "continuous"
    t.integer "old"
    t.text "training"
    t.text "vacation"
    t.text "childcare"
    t.text "recruit_univ"
    t.text "univ_depart"
    t.date "start_at"
    t.date "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "shareholder_meeting_on"
    t.date "board_meeting_on"
  end

  create_table "project_history_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "project_history_id"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_meets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "project_id"
    t.integer "project_offer_id"
    t.integer "project_applicant_id"
    t.integer "company_id"
    t.integer "student_id"
    t.datetime "start"
    t.datetime "end"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "remind_company_job_id"
    t.integer "remind_student_job_id"
  end

  create_table "project_terms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "project_id"
    t.datetime "finish_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "project_draft_id"
    t.integer "proposal_id"
    t.integer "company_id"
    t.string "name"
    t.string "image"
    t.string "interview_movie"
    t.integer "status", default: 0, null: false
    t.string "president_image"
    t.text "president_description"
    t.string "short_description"
    t.text "description", limit: 16777215
    t.text "company_info", limit: 16777215
    t.integer "number_hired"
    t.integer "revision", default: 1, null: false
    t.text "salary"
    t.text "process_selection"
    t.text "selection_condition"
    t.date "entry_closed"
    t.text "student_assumption"
    t.text "recruit_kind"
    t.text "duty_station"
    t.text "new_salary"
    t.text "allowance"
    t.text "raise_salary"
    t.text "reward"
    t.text "holiday"
    t.text "insurance"
    t.text "welfare_program"
    t.text "company_event"
    t.integer "sex_ratio"
    t.text "trial_period"
    t.text "other_welfare"
    t.integer "retired_ratio"
    t.integer "sex_ratio_hired"
    t.integer "continuous"
    t.integer "old"
    t.text "training"
    t.text "vacation"
    t.text "childcare"
    t.text "recruit_univ"
    t.text "univ_depart"
    t.date "start_at"
    t.date "end_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "shareholder_meeting_on"
    t.date "board_meeting_on"
    t.integer "applicants_count", default: 0, null: false
    t.integer "finish_job_id"
  end

  create_table "public_messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "admin_id"
    t.datetime "answer_time"
    t.integer "status", default: 0, null: false
    t.text "answer"
    t.string "name"
    t.string "email"
    t.string "phone"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "question_categories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.integer "rank", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "question_draft_questions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "question_draft_id"
    t.integer "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "question_drafts", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "question_category_id"
    t.string "name"
    t.text "asking"
    t.text "answer"
    t.integer "rank", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "question_questions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "parent_id"
    t.integer "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "questions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "question_draft_id"
    t.integer "question_category_id"
    t.string "name"
    t.text "asking"
    t.text "answer"
    t.integer "rank", default: 0, null: false
    t.integer "impressions_count", default: 0
    t.integer "cached_votes_total", default: 0
    t.integer "cached_votes_score", default: 0
    t.integer "cached_votes_up", default: 0
    t.integer "cached_votes_down", default: 0
    t.integer "cached_weighted_score", default: 0
    t.integer "cached_weighted_total", default: 0
    t.float "cached_weighted_average", default: 0.0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cached_votes_down"], name: "index_questions_on_cached_votes_down"
    t.index ["cached_votes_score"], name: "index_questions_on_cached_votes_score"
    t.index ["cached_votes_total"], name: "index_questions_on_cached_votes_total"
    t.index ["cached_votes_up"], name: "index_questions_on_cached_votes_up"
    t.index ["cached_weighted_average"], name: "index_questions_on_cached_weighted_average"
    t.index ["cached_weighted_score"], name: "index_questions_on_cached_weighted_score"
    t.index ["cached_weighted_total"], name: "index_questions_on_cached_weighted_total"
  end

  create_table "quit_quit_reasons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "quit_id"
    t.integer "quit_reason_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quit_reasons", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.integer "rank", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quits", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "report_items", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "report_id"
    t.integer "student_transaction_record_id"
    t.integer "order_id"
    t.datetime "deliv_at"
    t.datetime "payment_at"
    t.integer "payment"
    t.text "company_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reports", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.integer "student_id"
    t.integer "report_type"
    t.string "report_type_name"
    t.integer "status", default: 0, null: false
    t.integer "version"
    t.integer "balance"
    t.text "sheet"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resumes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.string "company"
    t.string "office"
    t.date "started_on"
    t.date "finished_on"
    t.boolean "is_working"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "schedules", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "project_id"
    t.string "title"
    t.text "description"
    t.date "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sessions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "sites", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "project_id"
    t.integer "execution_price"
    t.integer "fastest_second"
    t.integer "fastest_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sliders", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "slider_type"
    t.integer "project_id"
    t.integer "event_id"
    t.integer "headline_id"
    t.integer "rank", default: 0, null: false
    t.string "image"
    t.string "bg_image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "staff_group_chat_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.bigint "staff_id"
    t.bigint "group_chat_category_id"
    t.bigint "group_chat_id"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_chat_category_id"], name: "index_staff_group_chat_categories_on_group_chat_category_id"
    t.index ["group_chat_id"], name: "index_staff_group_chat_categories_on_group_chat_id"
    t.index ["staff_id"], name: "index_staff_group_chat_categories_on_staff_id"
  end

  create_table "staffs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.integer "company_id"
    t.string "first_name"
    t.string "first_name_kana"
    t.string "last_name"
    t.string "last_name_kana"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.datetime "rejected_at"
    t.index ["deleted_at"], name: "index_staffs_on_deleted_at"
  end

  create_table "student_abilities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "student_id"
    t.integer "admin_id"
    t.decimal "ability_1", precision: 2, scale: 1
    t.decimal "ability_2", precision: 2, scale: 1
    t.decimal "ability_3", precision: 2, scale: 1
    t.decimal "ability_4", precision: 2, scale: 1
    t.decimal "ability_5", precision: 2, scale: 1
    t.decimal "ability_6", precision: 2, scale: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_agreements", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.integer "student_id"
    t.boolean "pdf1", default: false, null: false
    t.boolean "pdf2", default: false, null: false
    t.boolean "pdf3", default: false, null: false
    t.boolean "pdf4", default: false, null: false
    t.boolean "pdf5", default: false, null: false
    t.boolean "agreement", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_student_agreements_on_deleted_at"
  end

  create_table "student_applicants", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "student_id"
    t.integer "status"
    t.datetime "book_at"
    t.datetime "book1_at"
    t.datetime "book2_at"
    t.datetime "book3_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "meet_type"
  end

  create_table "student_change_notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "student_id"
    t.string "first_name"
    t.string "first_name_prev"
    t.string "last_name"
    t.string "last_name_prev"
    t.string "first_name_kana"
    t.string "first_name_kana_prev"
    t.string "last_name_kana"
    t.string "last_name_kana_prev"
    t.string "zip_code"
    t.string "zip_code_prev"
    t.string "prefecture_id"
    t.string "prefecture_id_prev"
    t.string "city"
    t.string "city_prev"
    t.string "address1"
    t.string "address1_prev"
    t.string "address2"
    t.string "address2_prev"
    t.integer "bank_id"
    t.integer "bank_id_prev"
    t.integer "bank_branch_id"
    t.integer "bank_branch_id_prev"
    t.integer "bank_account_type"
    t.integer "bank_account_type_prev"
    t.string "bank_account_number"
    t.string "bank_account_number_prev"
    t.string "bank_account_name"
    t.string "bank_account_name_prev"
    t.boolean "name_modified", default: false, null: false
    t.boolean "address_modified", default: false, null: false
    t.boolean "bank_modified", default: false, null: false
    t.integer "gender"
    t.date "birth_on"
    t.string "phone"
    t.string "phone_mobile"
    t.integer "job"
    t.string "job_details"
    t.string "company"
    t.string "phone_company"
    t.string "email_company"
    t.string "file"
    t.datetime "identification_updated_at"
    t.datetime "notified_at"
    t.datetime "dm_sent_at"
    t.datetime "locked_at"
    t.string "confirmation_code"
    t.datetime "confirmation_code_sent_at"
    t.datetime "confirmed_at"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "student_id"
    t.string "last_name"
    t.string "first_name"
    t.string "last_name_kana"
    t.string "first_name_kana"
    t.string "nickname"
    t.integer "gender"
    t.date "birth_on"
    t.string "zip_code"
    t.integer "prefecture_id"
    t.string "city"
    t.string "address1"
    t.string "address2"
    t.string "phone"
    t.string "phone_mobile"
    t.integer "university"
    t.string "university_name"
    t.boolean "bunri"
    t.integer "depart"
    t.integer "graduation_year"
    t.integer "graduation_month"
    t.integer "industry_1"
    t.integer "occupation_1"
    t.string "toeic_score"
    t.integer "revision"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_interests", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_list_emails", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "student_list_id"
    t.integer "admin_id"
    t.integer "job_id"
    t.string "subject"
    t.text "plain"
    t.text "rich"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_list_students", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "student_list_id"
    t.integer "student_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "student_lists", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "benchmark_email_list_id"
    t.integer "students_count", default: 0, null: false
    t.string "name"
    t.json "query"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_student_lists_on_name", unique: true
  end

  create_table "student_status_histories", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "student_id"
    t.integer "status"
    t.boolean "is_identification_passed"
    t.boolean "is_antisocial_check_passed"
    t.string "mail_subject"
    t.text "mail_body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.string "first_name"
    t.string "first_name_kana"
    t.string "last_name"
    t.string "last_name_kana"
    t.string "nickname"
    t.integer "gender"
    t.date "birth_on"
    t.string "zip_code"
    t.integer "prefecture_id"
    t.string "city"
    t.string "address1"
    t.string "address2"
    t.string "phone"
    t.string "phone_mobile"
    t.boolean "bunri"
    t.integer "university"
    t.string "university_name"
    t.string "depart"
    t.string "depart_detail"
    t.string "labo"
    t.integer "industry_1"
    t.integer "occupation_1"
    t.integer "industry_2"
    t.integer "occupation_2"
    t.integer "industry_3"
    t.integer "occupation_3"
    t.boolean "intern_is"
    t.string "intern_company"
    t.string "intern_detail"
    t.string "intern_company_2"
    t.string "intern_detail_2"
    t.string "intern_company_3"
    t.string "intern_detail_3"
    t.integer "graduation_year"
    t.integer "graduation_month"
    t.integer "toeic_score"
    t.string "qualifications"
    t.text "introduce"
    t.text "mypr"
    t.string "circle"
    t.string "seminar"
    t.string "jobhuntingaxis_text"
    t.integer "jobhuntingaxis"
    t.text "club"
    t.text "change_history"
    t.datetime "remind_update_sent_at"
    t.integer "p_communication"
    t.integer "p_logical"
    t.integer "p_challenge"
    t.integer "p_lesdership"
    t.integer "p_teamwork"
    t.integer "p_global"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.string "activation_code"
    t.datetime "activated_at"
    t.datetime "applied_at"
    t.integer "remind_apply_job_id"
    t.datetime "rejected_at"
    t.datetime "approved_at"
    t.datetime "waiting_activation_at"
    t.integer "remind_activation_job_id"
    t.datetime "term_confirmed_at"
    t.text "card_note"
    t.datetime "locked_at"
    t.text "lock_reason"
    t.boolean "is_identification_passed"
    t.datetime "identified_at"
    t.integer "identifier_id"
    t.boolean "is_antisocial_check_passed"
    t.datetime "antisocial_checked_at"
    t.integer "antisocial_checker_id"
    t.integer "approver_id"
    t.integer "revision", default: 0, null: false
    t.datetime "reconfirm_applied_at"
    t.datetime "reconfirmed_at"
    t.boolean "is_ignore_ip_check", default: false, null: false
    t.boolean "is_ignore_phone_check", default: false, null: false
    t.boolean "is_mail_target", default: true, null: false
    t.integer "total_order_count", default: 0, null: false
    t.integer "total_order_price", default: 0, null: false
    t.integer "total_investment_price", default: 0, null: false
  end

  create_table "summernotes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "admin_id"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "supporters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.string "first_name"
    t.string "first_name_kana"
    t.string "last_name"
    t.string "last_name_kana"
    t.string "office"
    t.integer "company_supporter_messages_count", default: 0, null: false
    t.boolean "can_view_project", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_supporters_on_deleted_at"
  end

  create_table "transaction_records", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "type"
    t.integer "user_id"
    t.integer "company_id"
    t.integer "student_id"
    t.integer "project_id"
    t.integer "product_id"
    t.integer "order_id"
    t.integer "amount"
    t.integer "transaction_type"
    t.datetime "transaction_at"
    t.integer "depository", default: 0, null: false
    t.integer "credit", default: 0, null: false
    t.integer "balance", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "upload_files", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "uploadable_id"
    t.string "uploadable_type"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_connections", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.string "access_token"
    t.string "display_name"
    t.string "expire_time"
    t.string "image_url"
    t.string "profile_url"
    t.string "provider_id"
    t.string "provider_user_id"
    t.integer "rank"
    t.string "refresh_token"
    t.string "secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
    t.index ["user_id"], name: "index_user_connections_on_user_id"
  end

  create_table "user_tokens", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.string "device_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expires_at"
    t.index ["user_id"], name: "index_user_tokens_on_user_id"
  end

  create_table "users", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.boolean "email_stop"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.integer "remind_apply_job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_roles", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
  end

  create_table "versions", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object", limit: 4294967295
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  create_table "visits", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.text "landing_page"
    t.integer "user_id"
    t.string "referring_domain"
    t.text "search_keyword"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.integer "screen_height"
    t.integer "screen_width"
    t.string "country"
    t.string "region"
    t.string "city"
    t.string "postal_code"
    t.decimal "latitude", precision: 10
    t.decimal "longitude", precision: 10
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.timestamp "started_at"
    t.index ["user_id"], name: "index_visits_on_user_id"
    t.index ["visit_token"], name: "index_visits_on_visit_token", unique: true
  end

  create_table "votes", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC", force: :cascade do |t|
    t.string "votable_type"
    t.integer "votable_id"
    t.string "voter_type"
    t.integer "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
  end

  add_foreign_key "company_supporter_messages", "group_chats"
  add_foreign_key "consultations", "group_chat_categories"
  add_foreign_key "consultations", "supporters"
  add_foreign_key "group_chat_category_supporters", "group_chat_categories"
  add_foreign_key "group_chat_category_supporters", "supporters"
  add_foreign_key "group_chat_members", "group_chats"
  add_foreign_key "mailboxer_conversation_opt_outs", "mailboxer_conversations", column: "conversation_id", name: "mb_opt_outs_on_conversations_id"
  add_foreign_key "mailboxer_notifications", "mailboxer_conversations", column: "conversation_id", name: "notifications_on_conversation_id"
  add_foreign_key "mailboxer_receipts", "mailboxer_notifications", column: "notification_id", name: "receipts_on_notification_id"
  add_foreign_key "staff_group_chat_categories", "group_chat_categories"
  add_foreign_key "staff_group_chat_categories", "group_chats"
  add_foreign_key "staff_group_chat_categories", "staffs"
end
