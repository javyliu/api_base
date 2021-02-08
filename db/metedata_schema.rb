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

ActiveRecord::Schema.define(version: 0) do

  create_table "auto_warn_info", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "auto_warn_task_id"
    t.string "data_time", limit: 10
    t.string "warn_info", limit: 254
    t.integer "warn_level"
  end

  create_table "auto_warn_task", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "warn_name", limit: 50
    t.string "run_time", limit: 5
    t.string "related_report_name", limit: 50
    t.string "related_report", limit: 100
    t.string "related_report_type", limit: 50
    t.text "warn_task"
    t.integer "delete_flag", default: 0
    t.datetime "last_update_time"
    t.string "moreover", limit: 100
  end

  create_table "market_category", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "categoryName"
    t.string "userName"
    t.string "createTime"
  end

  create_table "market_resource", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "resourceid", null: false
    t.string "name"
    t.string "url"
    t.text "supportgame"
    t.string "supporttype", limit: 2
    t.integer "showorder"
    t.text "notice"
    t.index ["resourceid"], name: "resourceid", unique: true
  end

  create_table "market_user", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "username"
    t.string "password", null: false
    t.string "foreignuser"
    t.text "managerothername"
    t.text "supportresource"
    t.text "supportgamechannel"
    t.string "createtime"
    t.text "notice"
    t.string "status"
  end

  create_table "market_user_game_resource", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "userid"
    t.text "gameid"
    t.text "resourceid"
    t.integer "superid"
    t.text "notice"
    t.index ["userid"], name: "userid", unique: true
  end

  create_table "market_user_log", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "userName", null: false
    t.string "status"
    t.string "loginTime"
    t.string "ip"
  end

  create_table "market_user_reportlog", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "userName", null: false
    t.integer "reportId", null: false
    t.string "accessTime"
  end

  create_table "t_data_file", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "dataid"
    t.string "filename"
    t.string "filepath"
    t.string "modifytime"
    t.string "memo"
    t.integer "flag"
    t.string "url"
  end

  create_table "t_data_info", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "title"
    t.string "filetype"
    t.string "author"
    t.string "summary"
    t.string "createtime"
    t.string "reqname"
    t.string "uploader"
    t.string "memo"
  end

  create_table "t_data_type", primary_key: "dataTypeId", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "timeAdded", null: false
    t.string "userName", limit: 10, null: false
    t.string "dataTypeName", limit: 10, null: false
  end

  create_table "t_game_region", id: :integer, charset: "gbk", collation: "gbk_bin", force: :cascade do |t|
    t.integer "regionId", default: 0, null: false
    t.string "regionName", limit: 30
    t.integer "gameId", default: 0, null: false
    t.string "gameName", limit: 20
    t.integer "regionState", default: 1
    t.integer "gameIdNew"
    t.text "combineRegion", collation: "gbk_chinese_ci"
    t.string "serverip", limit: 50
    t.string "serverport", limit: 25
    t.string "logpath", limit: 200
  end

  create_table "t_purview_disable", id: :integer, charset: "gbk", collation: "gbk_bin", force: :cascade do |t|
    t.integer "userId", null: false
    t.integer "reportId", null: false
    t.integer "systemId", null: false
  end

  create_table "t_purview_expand", id: :integer, charset: "gbk", collation: "gbk_bin", force: :cascade do |t|
    t.integer "userId", null: false
    t.integer "reportId", null: false
    t.integer "systemId", null: false
  end

  create_table "t_purview_group", id: :integer, charset: "gbk", collation: "gbk_bin", force: :cascade do |t|
    t.string "purName", limit: 100, null: false
    t.integer "systemId", null: false
    t.string "remark", limit: 100
  end

  create_table "t_purview_relation", id: :integer, charset: "gbk", collation: "gbk_bin", force: :cascade do |t|
    t.integer "purId", null: false
    t.integer "reportId", null: false
    t.integer "systemId", null: false
  end

  create_table "t_report_log", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "userId", null: false
    t.string "userName", limit: 100
    t.integer "reportId", null: false
    t.string "method"
    t.string "createTime", limit: 50, null: false
    t.integer "systemid"
  end

  create_table "t_system_info", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "systemName", limit: 50, null: false
    t.integer "orderNum", null: false
    t.integer "status", null: false
    t.string "url", limit: 100
  end

  create_table "t_user", id: :integer, charset: "gbk", collation: "gbk_bin", force: :cascade do |t|
    t.string "userName", limit: 50, default: "", null: false
    t.string "name", limit: 50
    t.string "password", limit: 150, default: "", null: false
    t.string "remark", limit: 50, default: ""
    t.integer "enable", default: 1, null: false, comment: "1为暂停, 2:用户解除当日禁用行为,解禁完后自动转成0。0:可登陆"
    t.string "homepage", default: "0", comment: "0: 默认页，1:自动预警页面，2:游戏数据汇总表"
    t.string "pagemodule", default: ""
    t.string "deptName", limit: 100
    t.integer "userType", null: false
    t.string "disableTime", limit: 20, null: false
    t.integer "tryNum", null: false
    t.string "lastLoginTime", limit: 20
    t.string "lastLoginIp", limit: 20
    t.string "email"
    t.string "browser"
    t.integer "market", default: 0, comment: "是否是市场用户0是,1否"
    t.string "marketuser", comment: "拥有下级用户id以,隔开"
  end

  create_table "t_user_game", id: :integer, charset: "gbk", collation: "gbk_bin", force: :cascade do |t|
    t.integer "userId", null: false
    t.integer "gameId", null: false
    t.integer "systemId", null: false
  end

  create_table "t_user_log", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "userName", limit: 50, null: false
    t.string "ip", limit: 20, null: false
    t.string "time", limit: 20, null: false
    t.integer "systemId", null: false, comment: "系统ID\r\n0　：　通用登录\r\n1　：　PIPCOUNT平台\r\n2　：　FLASH三国平台\r\n可由t_system_info中获得ID"
    t.integer "result", null: false, comment: "0 正常登录\r\n1 密码不正确\r\n2 帐号已经被封停\r\n3 帐号已经被冻结"
    t.string "area", limit: 50, comment: "ip区域城市省份"
    t.string "browser", limit: 150
  end

  create_table "t_user_purviewgroup", id: :integer, charset: "gbk", collation: "gbk_bin", force: :cascade do |t|
    t.integer "userId", null: false
    t.integer "purviewGroupId", null: false
    t.integer "systemId", null: false
  end

  create_table "tbl_dept", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "deptName"
    t.string "userName"
    t.string "createTime"
  end

  create_table "tbl_game_info", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "gameId", default: 0, null: false
    t.string "gameName", limit: 20, collation: "gbk_bin"
    t.string "gameLogFormat", limit: 20, collation: "gbk_bin"
    t.string "gameItemConfig", limit: 30, collation: "gbk_bin"
    t.string "gameImoneyRate", limit: 10, collation: "gbk_bin"
    t.string "gameMinver", limit: 10, collation: "gbk_bin"
    t.string "gameAccFormat", limit: 20, collation: "gbk_bin"
    t.text "gameCodes"
    t.integer "gameAttrsCount"
    t.string "gameAttrsRate", limit: 10, collation: "gbk_bin"
    t.integer "gameHpmpCount"
    t.string "gameHpmpRate", limit: 10, collation: "gbk_bin"
    t.integer "gameState", default: 1
    t.integer "channelShow", default: 1
    t.string "systemId", limit: 10, collation: "gbk_bin"
    t.integer "showOrder"
    t.integer "registerOnLineTime", default: 4, comment: "在线时长限制注册数"
    t.integer "gamemodel", default: 0, comment: "游戏运营模式 0自营1代理"
    t.integer "registerLevel", default: 2, comment: "级别限制注册数"
    t.integer "billing_gamecode"
    t.date "stopservertime", default: "3000-01-01"
  end

  create_table "tbl_game_relation", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "oldId", null: false
    t.integer "newId", null: false
    t.integer "systemId", null: false
  end

  create_table "tbl_notice", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "publisher"
    t.string "title"
    t.string "content"
    t.string "noticetime"
  end

  create_table "tbl_purview", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "userid"
    t.integer "gameid"
    t.integer "purid"
  end

  create_table "tbl_report", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "resourceid", null: false
    t.string "name", limit: 50
    t.string "uri", limit: 200
    t.text "supportgame"
    t.integer "supporttype"
    t.integer "vestin"
    t.integer "showorder"
    t.string "status", limit: 2
    t.text "notice"
    t.string "method", limit: 100, comment: "action请求方法名称，权限控制时使用"
    t.string "english", limit: 500
    t.index ["resourceid"], name: "resourceid", unique: true
  end

  create_table "tbl_resource", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "resourceid", null: false
    t.string "name", limit: 50
    t.string "uri", limit: 200
    t.text "supportgame"
    t.integer "fatherresource"
    t.string "reportcategory", limit: 2
    t.string "supporttype", limit: 2
    t.integer "vestin"
    t.integer "showorder"
    t.string "status", limit: 2
    t.text "notice"
    t.index ["resourceid"], name: "resourceid", unique: true
  end

  create_table "tbl_resource_system", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "resourceId", null: false
    t.string "supportgame", limit: 200
    t.string "typeName", limit: 200
    t.string "name", limit: 200, null: false
    t.integer "systemId", null: false
    t.integer "chart", default: 0
  end

  create_table "tbl_role", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "roleid", comment: "角色编号"
    t.string "rolename", comment: "角色名称"
    t.integer "state", default: 1, comment: "状态是有效,1为有效,0为无效"
    t.integer "systemid", default: 100, comment: "系统id"
    t.integer "showorder", comment: "排序显示方式"
    t.string "demo", comment: "备注说明信息"
  end

end
