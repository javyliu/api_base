# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_07_13_034427) do

  create_table "accounts", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "user_name"
    t.integer "game_user_id"
    t.string "lottery_num", limit: 1000
    t.string "nickname"
    t.string "email"
    t.integer "intergal", default: 0
    t.integer "charmvalue", default: 0
    t.string "remember_token"
    t.datetime "remember_token_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_user_id"], name: "index_accounts_on_game_user_id"
    t.index ["remember_token"], name: "index_accounts_on_remember_token"
    t.index ["user_name"], name: "index_accounts_on_user_name"
  end

  create_table "activities", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "realname", limit: 20
    t.string "nickname", limit: 20
    t.string "phone", limit: 20, collation: "latin1_swedish_ci"
    t.string "qq", limit: 20, collation: "latin1_swedish_ci"
    t.string "email", limit: 150, collation: "latin1_swedish_ci"
    t.string "address"
    t.string "partition", limit: 150
    t.string "constellation", limit: 20
    t.string "description", limit: 150
    t.string "pic_1", collation: "latin1_swedish_ci"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pic"
    t.integer "votes_count"
    t.string "sina_weibo"
    t.boolean "queen", default: false
    t.boolean "is_show", default: true
  end

  create_table "activity_images", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "activity_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture_file_name"
    t.string "picture_content_type", collation: "latin1_swedish_ci"
    t.integer "picture_file_size"
    t.boolean "audit"
    t.boolean "cover"
    t.index ["activity_id"], name: "index_activity_images_on_activity_id"
  end

  create_table "anti_addictions", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "cardno"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_anti_addictions_on_user_id"
  end

  create_table "box_activate_logs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "device_id", limit: 50, collation: "latin1_swedish_ci"
    t.string "remote_addr", limit: 20, collation: "latin1_swedish_ci"
    t.string "channel", limit: 10, collation: "latin1_swedish_ci"
    t.integer "activate_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channel_downloads", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", limit: 50
    t.string "name_en", limit: 20
    t.string "img_icon"
    t.string "link_address"
    t.string "version", limit: 50
    t.string "package_size", limit: 100
    t.string "update_date", limit: 20
    t.integer "game_id", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "platform", limit: 20
    t.index ["game_id"], name: "index_channel_downloads_on_game_id"
  end

  create_table "channels", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "channel_code"
    t.string "version"
    t.integer "game_id"
    t.string "game_icon"
    t.string "style"
    t.string "firmware"
    t.string "zifei"
    t.string "package_name"
    t.string "package_size"
    t.text "description", size: :medium
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "page_title"
  end

  create_table "code_emails", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "email"
    t.string "from"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "email_id"
    t.index ["email_id", "email"], name: "by_eid_scope", unique: true
  end

  create_table "customize_pages", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cycles", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "img_src"
    t.string "link_address"
    t.integer "game_id"
    t.string "alt_text"
    t.string "position"
    t.integer "ord"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["game_id"], name: "index_cycles_on_game_id"
  end

  create_table "delayed_jobs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "emails", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "subject", limit: 250
    t.text "content"
    t.text "emails", size: :medium
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "sender_user"
    t.boolean "has_activate_code"
    t.string "opts"
  end

  create_table "f_activities", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "address", limit: 200
    t.integer "start_page"
    t.integer "end_page"
    t.string "forum_name", limit: 10
    t.text "curl_text"
    t.string "message_txt"
    t.binary "activity_codes", size: :medium
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title", limit: 100
  end

  create_table "f_comments", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "uid"
    t.string "uname"
    t.integer "f_activity_id"
    t.integer "page"
    t.text "content"
    t.index ["f_activity_id"], name: "index_f_comments_on_f_activity_id"
    t.index ["uid"], name: "index_f_comments_on_uid"
  end

  create_table "fax_form_opts", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", limit: 20
    t.string "value"
    t.integer "fax_form_id"
    t.integer "ord", limit: 2, default: 0
    t.index ["fax_form_id"], name: "index_fax_form_opts_on_fax_form_id"
  end

  create_table "fax_forms", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "game_id", limit: 2
    t.string "game_server_name", limit: 100
    t.string "game_server_id", limit: 100
    t.integer "cate", limit: 1
    t.string "game_user_name", limit: 100
    t.string "game_role_name", limit: 100
    t.string "game_role_level", limit: 10
    t.string "card_pics", limit: 2000
    t.integer "state", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reply_user_name"
    t.string "answer"
    t.datetime "response_time"
    t.index ["game_id"], name: "index_fax_forms_on_game_id"
    t.index ["user_id"], name: "index_fax_forms_on_user_id"
  end

  create_table "game_presents", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "game_id", limit: 3
    t.integer "ord", limit: 3
    t.string "img"
    t.integer "num"
    t.integer "w_activity_id"
    t.string "cate", limit: 10
    t.string "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_game_presents_on_game_id"
    t.index ["w_activity_id"], name: "index_game_presents_on_w_activity_id"
  end

  create_table "game_user_total_times", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "time_m"
    t.integer "time_d"
  end

  create_table "k_activities", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "game_id"
    t.integer "state"
    t.string "start_time", limit: 80
    t.string "end_time", limit: 80
    t.string "server_name"
    t.text "content"
    t.integer "awarding_form"
    t.string "remark"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pic"
    t.index ["game_id"], name: "index_k_activities_on_game_id"
  end

  create_table "k_qas", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "question", limit: 2000
    t.string "answer", limit: 4000
    t.integer "k_tedan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "q_user_name"
    t.string "a_user_name"
    t.index ["k_tedan_id"], name: "index_k_qas_on_k_tedan_id"
  end

  create_table "k_tedans", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "game_id"
    t.string "partition"
    t.string "game_user"
    t.string "game_role"
    t.string "order_number"
    t.string "charge_pics", limit: 2000
    t.string "charge_at", limit: 2000
    t.string "user_name"
    t.string "handle_result", limit: 4000
    t.integer "state", limit: 1
    t.string "kefu_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cate_id"
    t.string "issure_date"
    t.integer "k_qas_count"
    t.integer "vip", limit: 1
    t.index ["charge_at"], name: "index_k_tedans_on_charge_at", length: 255
    t.index ["game_id"], name: "index_k_tedans_on_game_id"
    t.index ["game_user"], name: "index_k_tedans_on_game_user"
    t.index ["order_number"], name: "index_k_tedans_on_order_number"
    t.index ["user_name"], name: "index_k_tedans_on_user_name"
  end

  create_table "kjmails", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "author"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_zones", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.string "address"
    t.string "logo_img"
    t.integer "ord"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_id"
    t.string "logo_address"
  end

  create_table "mkeywords", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "identity_name", limit: 20
    t.string "name"
    t.string "format_str"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "game_id", default: 0
    t.index ["game_id"], name: "index_mkeywords_on_game_id"
    t.index ["identity_name"], name: "index_mkeywords_on_identity_name"
  end

  create_table "mobile_brands", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "cn", limit: 40
    t.string "initial", limit: 1
    t.string "en", limit: 20
    t.boolean "hot", default: false
  end

  create_table "mobile_models", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "cn", limit: 20
    t.string "en", limit: 30
    t.integer "mobile_brand_id"
    t.string "platform", limit: 20
    t.boolean "hot"
    t.index ["mobile_brand_id"], name: "index_mobile_models_on_mobile_brand_id"
  end

  create_table "model_parameters", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "marker_time", limit: 8
    t.string "net_style", limit: 20
    t.string "battery_capacity", limit: 100
    t.string "facade", limit: 10
    t.string "bluetooth", limit: 10
    t.string "size", limit: 100
    t.string "gps", limit: 10
    t.string "touch_screen", limit: 10
    t.string "card", limit: 50
    t.string "camera", limit: 100
    t.string "ringtone", limit: 200
    t.string "system", limit: 30
    t.string "price", limit: 20
    t.string "memory", limit: 20
    t.string "img_src"
    t.integer "mobile_model_id"
    t.index ["mobile_model_id"], name: "index_model_parameters_on_mobile_model_id"
  end

  create_table "os_configs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "key", limit: 40
    t.string "des", limit: 40
    t.string "value"
  end

  create_table "pearl_users", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "email", limit: 40
    t.string "name_en", limit: 30
    t.string "realname", limit: 50
    t.datetime "reg_on"
    t.string "identity", limit: 32
    t.boolean "group_user"
    t.index ["email"], name: "index_pearl_users_on_email"
    t.index ["identity"], name: "index_pearl_users_on_identity"
  end

  create_table "pictures", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "game_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "img_file_name"
    t.string "pic_type"
    t.index ["game_id"], name: "index_pictures_on_game_id"
  end

  create_table "pipgame_chenmi", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "applicant", limit: 10, null: false, comment: "申请人姓名"
    t.string "ward", limit: 10, null: false, comment: "被申请人姓名"
    t.string "relationship", limit: 15, comment: "与被申请人关系"
    t.string "contact", comment: "联系方式"
    t.string "email", comment: "电子邮件"
    t.datetime "app_time", comment: "申请时间"
    t.integer "game_id", comment: "申请产品（游戏）"
    t.string "account", comment: "账号信息"
    t.string "role", comment: "角色详情"
    t.integer "processing_steps", comment: "处理步骤"
    t.text "processing_detail", comment: "处理详情"
    t.text "memo", comment: "备注"
    t.string "sid", comment: "申请单号"
  end

  create_table "pipgame_downgroup", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "game_type", null: false
    t.string "groupname", limit: 20, null: false
    t.string "includetypes", limit: 200, null: false
    t.string "memo", limit: 100
    t.string "shortname", limit: 10
    t.string "name_en", limit: 20
  end

  create_table "pipgame_downtype", id: :integer, charset: "gbk", force: :cascade do |t|
    t.text "mobile_type", size: :tiny
    t.integer "game_type", default: 0
    t.text "file_name", size: :tiny
    t.string "mobiles", limit: 2000, default: "?¨2D¨a"
    t.integer "priority", default: 0
    t.string "memo", limit: 200, default: "NULL"
    t.boolean "other", default: false
    t.integer "state", default: 0
  end

  create_table "pipgame_game", id: :integer, charset: "gbk", options: "ENGINE=InnoDB ROW_FORMAT=REDUNDANT", force: :cascade do |t|
    t.string "name_cn", limit: 50
    t.string "short_name_cn", limit: 50
    t.string "name_en", limit: 50
    t.string "short_name_en", limit: 50
    t.string "provider", limit: 50
    t.string "version", limit: 50
    t.text "description", size: :medium
    t.text "summary", size: :medium
    t.text "background", size: :medium
    t.text "guide", size: :medium
    t.text "characteristic", size: :medium
    t.text "war_field", size: :medium
    t.text "task", size: :medium
    t.text "war", size: :medium
    t.text "trade", size: :medium
    t.text "tearcher_student", size: :medium
    t.text "marriage", size: :medium
    t.text "npc", size: :medium
    t.text "rule", size: :medium
    t.text "disobey_rule", size: :medium
    t.integer "game_type", default: 0
    t.integer "platform_type", default: 0
    t.integer "net_flag", default: 0
    t.integer "attention_grade", default: 0
    t.datetime "create_time", default: "2008-12-01 10:40:29"
    t.datetime "modify_time", default: "2008-12-01 10:40:29"
    t.integer "delete_flag", default: 0
    t.integer "game_order", default: -1
  end

  create_table "pipgame_gw_games", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pipgame_gw_info", id: :integer, charset: "gbk", options: "ENGINE=InnoDB ROW_FORMAT=REDUNDANT", force: :cascade do |t|
    t.integer "gameid", default: 0, unsigned: true
    t.string "title"
    t.text "content", size: :medium, collation: "utf8_general_ci"
    t.string "remark"
    t.string "info_name", limit: 50, default: ""
    t.integer "info_flag", default: 1
    t.integer "pri", default: 0
    t.datetime "create_time"
    t.datetime "modify_time"
    t.integer "delete_flag", default: 0
    t.string "keywords"
    t.string "dis_img_file_name"
    t.string "dis_img_content_type"
    t.integer "ord"
    t.boolean "hot"
    t.string "locale", limit: 30, default: "zh"
    t.index ["gameid"], name: "index_pipgame_gw_info_on_gameid"
  end

  create_table "pipgame_gw_material_cates", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "game_id"
    t.string "title"
    t.integer "ord"
    t.index ["game_id"], name: "index_pipgame_gw_material_cates_on_game_id"
  end

  create_table "pipgame_gw_materials", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "identity_name"
    t.integer "material_cate_id"
    t.integer "game_id"
    t.string "title"
    t.string "keywords"
    t.string "description"
    t.text "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["game_id"], name: "index_pipgame_gw_materials_on_game_id"
    t.index ["material_cate_id"], name: "index_pipgame_gw_materials_on_material_cate_id"
  end

  create_table "pipgame_info", id: :integer, charset: "gbk", options: "ENGINE=InnoDB ROW_FORMAT=REDUNDANT", force: :cascade do |t|
    t.text "title", size: :medium
    t.text "content", size: :medium
    t.text "remark", size: :medium
    t.string "info_name", limit: 50, default: "新闻"
    t.integer "info_flag", default: 1
    t.integer "top_flag", default: 0
    t.integer "pri", default: 0
    t.integer "link_to_flag", default: 0
    t.integer "news_type", default: 0
    t.integer "forum_node_id", default: -1
    t.integer "forum_node_author_id", default: -1
    t.string "forum_node_author_name", limit: 50
    t.integer "reserved_flag", default: 0
    t.integer "operate_user_id", default: -1
    t.datetime "create_time"
    t.datetime "modify_time"
    t.integer "delete_flag", default: 0
    t.integer "gid", default: 0, null: false
  end

  create_table "pipgame_info_game", id: :integer, charset: "gbk", options: "ENGINE=InnoDB ROW_FORMAT=REDUNDANT", force: :cascade do |t|
    t.integer "info_id", null: false
    t.integer "game_id", null: false
    t.index ["game_id"], name: "ix_pig_game_id"
    t.index ["info_id"], name: "ix_pig_info_id"
  end

  create_table "pipgame_plat_device", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "device_name", limit: 11, null: false
    t.string "device_type", limit: 12
    t.string "package_hx", limit: 50
    t.string "package_wl", limit: 50
    t.string "package_ly", limit: 50
    t.string "package_sg", limit: 50
  end

  create_table "pipgame_subnet_spread", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title", limit: 120
    t.text "content"
    t.integer "type", null: false
    t.string "addtime", limit: 19, null: false
    t.integer "state", null: false
    t.string "img", limit: 120, null: false
  end

  create_table "pipgame_user_info", id: { type: :bigint, unsigned: true }, charset: "gbk", force: :cascade do |t|
    t.string "user_name", limit: 20, null: false
    t.string "nick_name", limit: 20
    t.string "password_digest", limit: 72, null: false
    t.string "email", limit: 50
    t.datetime "add_Time"
    t.datetime "modify_Time"
    t.integer "delete_flag", default: 0, null: false
    t.string "role", limit: 40
  end

  create_table "pipgame_web_link", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "url", limit: 500
    t.string "location", limit: 100
    t.integer "ord"
    t.string "link_name", limit: 50
    t.string "category", limit: 10
    t.datetime "created_at"
    t.datetime "limited_at"
  end

  create_table "pnames", id: :integer, charset: "utf8", force: :cascade do |t|
    t.text "desc"
    t.integer "num", limit: 1
    t.integer "game_id"
    t.integer "state", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.integer "style", limit: 1
    t.index ["game_id"], name: "index_pnames_on_game_id"
  end

  create_table "presents", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.integer "num", default: 0
    t.integer "ord", default: 0
    t.integer "w_activity_id"
    t.boolean "default"
    t.integer "prob_1"
    t.integer "prob_2"
    t.integer "prob_3"
    t.integer "prob_4"
    t.integer "lock_version", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cate", default: 0
    t.string "obtained_users", limit: 20000
    t.integer "amount", default: 0
    t.string "pic"
    t.index ["w_activity_id"], name: "index_presents_on_w_activity_id"
  end

  create_table "pvote_logs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "pvote_id"
    t.integer "pearl_user_id"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pearl_user_id"], name: "index_pvote_logs_on_pearl_user_id"
    t.index ["pvote_id"], name: "index_pvote_logs_on_pvote_id"
    t.index ["value"], name: "index_pvote_logs_on_value"
  end

  create_table "pvotes", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "desc", limit: 3000
    t.integer "pname_id"
    t.integer "state", limit: 1
    t.integer "num", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.index ["pname_id"], name: "index_pvotes_on_pname_id"
  end

  create_table "pwords", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", limit: 1000
    t.integer "pearl_user_id"
    t.integer "state", limit: 1
    t.integer "vote_count"
    t.integer "pname_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "design_picture"
    t.index ["pearl_user_id"], name: "index_pwords_on_pearl_user_id"
    t.index ["pname_id"], name: "index_pwords_on_pname_id"
  end

  create_table "readed_news", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "news_id"
    t.integer "user_id"
    t.index ["news_id"], name: "index_readed_news_on_news_id"
    t.index ["user_id"], name: "index_readed_news_on_user_id"
  end

  create_table "role_resources", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "role_id"
    t.string "resource_name", limit: 50
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["resource_name"], name: "index_role_resources_on_resource_name"
    t.index ["role_id"], name: "index_role_resources_on_role_id"
  end

  create_table "roles", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", limit: 20
    t.string "display_name", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "index_roles_on_name"
  end

  create_table "roles_users", id: false, charset: "latin1", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.index ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id", unique: true
  end

  create_table "rsh_votes", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "rsh_id"
    t.string "game_name"
    t.text "vote_detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rsh_id"], name: "index_rsh_votes_on_rsh_id"
  end

  create_table "rshes", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "research_id"
    t.integer "game_id"
    t.string "selected", limit: 500
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.integer "w_activity_id"
    t.index ["research_id", "game_id"], name: "rsh_r_g"
  end

  create_table "short_links", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "channel"
    t.string "target", limit: 500
    t.string "cate", limit: 50
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "need_log"
    t.boolean "redirect_identity", default: false
  end

  create_table "subscribe_users", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "phone", limit: 20
    t.integer "game_id", limit: 2
    t.string "platform", limit: 20
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id", "phone"], name: "index_subscribe_users_on_game_id_and_phone"
  end

  create_table "user_bindings", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "game_id"
    t.integer "game_user_id"
    t.string "partition"
    t.string "role_name"
    t.integer "w_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_user_bindings_on_game_id"
    t.index ["w_user_id"], name: "index_user_bindings_on_w_user_id"
  end

  create_table "vip_users", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "game_id"
    t.string "wx_nickname"
    t.string "game_user_name"
    t.integer "state", default: 0
    t.string "game_role_name"
    t.string "tel"
    t.string "user_from"
    t.date "registered_time"
    t.boolean "charged_in_month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "partition"
    t.string "access_from"
    t.index ["game_id"], name: "index_vip_users_on_game_id"
    t.index ["wx_nickname"], name: "index_vip_users_on_wx_nickname"
  end

  create_table "vote_logs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "ip", limit: 20
    t.integer "vote_time"
    t.integer "activity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["activity_id"], name: "index_vote_logs_on_activity_id"
    t.index ["ip"], name: "index_vote_logs_on_ip"
    t.index ["vote_time"], name: "index_vote_logs_on_vote_time"
  end

  create_table "w_activities", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "frequency"
    t.text "content"
    t.integer "w_type", limit: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "w_rule_id"
    t.integer "wechat_user_id"
    t.integer "parent_id"
    t.integer "total_count"
    t.string "game_scopes"
    t.datetime "charge_end_time"
    t.boolean "is_open"
    t.string "banner"
    t.string "short_des"
    t.integer "weight", limit: 1, default: 0, comment: "活动权重，设置默认活动时会按其排序"
    t.index ["w_rule_id"], name: "index_w_activities_on_w_rule_id"
    t.index ["wechat_user_id"], name: "index_w_activities_on_wechat_user_id"
  end

  create_table "w_activity_logs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "content"
    t.integer "w_activity_id"
    t.integer "w_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "extra_info"
    t.index ["w_user_id", "w_activity_id", "created_at", "extra_info"], name: "by_use_and_act_id_and_time"
  end

  create_table "w_art_items", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.integer "article_id"
    t.integer "item_type"
    t.integer "child_id"
    t.index ["article_id", "child_id"], name: "index_w_art_items_on_article_id_and_child_id"
    t.index ["article_id", "item_type"], name: "index_w_art_items_on_article_id_and_item_type"
    t.index ["child_id"], name: "index_w_art_items_on_child_id"
  end

  create_table "w_articles", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.string "pic"
    t.string "url"
    t.integer "ord"
    t.boolean "dis_pic"
    t.text "content"
    t.integer "game_id", limit: 2
    t.integer "matcher_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_w_articles_on_game_id"
    t.index ["matcher_id"], name: "index_w_articles_on_matcher_id"
    t.index ["ord"], name: "index_w_articles_on_ord"
  end

  create_table "w_codes", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "code"
    t.integer "w_activity_id"
    t.integer "codeable_id"
    t.string "codeable_type"
    t.index ["codeable_id", "codeable_type"], name: "code_type"
    t.index ["codeable_id", "codeable_type"], name: "poly_index"
    t.index ["w_activity_id"], name: "index_w_codes_on_w_activity_id"
  end

  create_table "w_items", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "identity_name"
    t.string "name"
    t.string "game_id"
    t.integer "w_type"
    t.integer "winfo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "w_content", size: :medium
    t.integer "code_type"
    t.index ["winfo_id"], name: "index_w_items_on_winfo_id"
  end

  create_table "w_kfs", id: :integer, charset: "utf8", options: "ENGINE=InnoDB ROW_FORMAT=REDUNDANT", force: :cascade do |t|
    t.string "kf_id", limit: 50, collation: "gbk_chinese_ci"
    t.string "worker", limit: 50, collation: "gbk_chinese_ci"
    t.string "kf_nick", limit: 50, collation: "gbk_chinese_ci"
    t.integer "w_wechat_user_id"
    t.string "kf_headimgurl", collation: "gbk_chinese_ci"
  end

  create_table "w_matchers", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "keyword"
    t.string "msg_type"
    t.string "answer", limit: 300
    t.integer "wechat_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "w_rule_id"
    t.index ["keyword"], name: "index_w_matchers_on_keyword"
    t.index ["w_rule_id"], name: "index_w_matchers_on_w_rule_id"
    t.index ["wechat_user_id"], name: "index_w_matchers_on_wechat_user_id"
  end

  create_table "w_msgs", id: :integer, charset: "utf8", options: "ENGINE=InnoDB ROW_FORMAT=REDUNDANT", force: :cascade do |t|
    t.string "worker", limit: 50, collation: "gbk_chinese_ci"
    t.string "openid", limit: 50, collation: "gbk_chinese_ci"
    t.string "opercode", limit: 50, collation: "gbk_chinese_ci"
    t.integer "time"
    t.integer "w_wechat_user_id"
    t.index ["openid"], name: "index_w_msgs_on_openid"
    t.index ["worker"], name: "worker_index"
  end

  create_table "w_rules", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "w_type"
  end

  create_table "w_users", id: :integer, charset: "utf8", options: "ENGINE=InnoDB ROW_FORMAT=REDUNDANT", force: :cascade do |t|
    t.string "openid", limit: 50, collation: "gbk_chinese_ci"
    t.string "nickname", limit: 50, collation: "gbk_chinese_ci"
    t.integer "wechat_user_id"
    t.boolean "subscribed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "groupid"
    t.integer "sex", limit: 1
    t.string "city", limit: 50
    t.string "country", limit: 50
    t.string "province", limit: 50
    t.string "avatar_file_name"
    t.string "unionid", limit: 100
    t.index ["openid"], name: "index_w_users_on_openid"
    t.index ["wechat_user_id"], name: "index_w_users_on_wechat_user_id"
  end

  create_table "w_wechat_infos", id: :integer, charset: "utf8", force: :cascade do |t|
    t.text "menu"
    t.integer "wechat_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["wechat_user_id"], name: "index_w_wechat_infos_on_wechat_user_id"
  end

  create_table "w_wechat_users", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name"
    t.string "pic"
    t.string "app_id"
    t.string "app_secret"
    t.string "app_token"
    t.string "wechat_secret_key"
    t.integer "user_id"
    t.integer "following_users_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "qr_code"
    t.boolean "kefu"
    t.string "w_name"
    t.index ["user_id"], name: "index_w_wechat_users_on_user_id"
    t.index ["wechat_secret_key"], name: "index_w_wechat_users_on_wechat_secret_key"
  end

  create_table "winfos", id: :integer, charset: "utf8", options: "ENGINE=InnoDB ROW_FORMAT=REDUNDANT", force: :cascade do |t|
    t.string "name", limit: 50, collation: "gbk_chinese_ci"
    t.string "short_name", limit: 50, collation: "gbk_chinese_ci"
    t.text "welcome", size: :medium, collation: "gbk_chinese_ci"
    t.text "err_notice", size: :medium, collation: "gbk_chinese_ci"
    t.datetime "create_time"
    t.datetime "modify_time"
    t.datetime "start"
    t.datetime "end"
  end

  create_table "zhaopin", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title", limit: 45
    t.integer "type_id"
    t.text "content"
    t.integer "ord"
    t.datetime "created_time"
    t.datetime "updated_time"
    t.index ["type_id"], name: "fsdfsdfsdf"
  end

  create_table "zhaopin_type", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title", limit: 45
    t.integer "ord", default: 0
  end

end
