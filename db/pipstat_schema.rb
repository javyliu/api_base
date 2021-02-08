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

ActiveRecord::Schema.define(version: 2019_10_31_041857) do

  create_table "Event", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "eventid", limit: 50
    t.integer "gamecode"
    t.string "gameregion", limit: 50
    t.string "key0", limit: 200
    t.string "value0", limit: 200
    t.string "key1", limit: 200
    t.string "value1", limit: 200
    t.string "key2", limit: 200
    t.string "value2", limit: 200
    t.string "key3", limit: 200
    t.string "value3", limit: 200
    t.string "key4", limit: 200
    t.string "value4", limit: 200
    t.string "key5", limit: 200
    t.string "value5", limit: 200
    t.string "key6", limit: 200
    t.string "value6", limit: 200
    t.string "key7", limit: 200
    t.string "value7", limit: 200
    t.string "key8", limit: 200
    t.string "value8", limit: 200
    t.string "key9", limit: 200
    t.string "value9", limit: 200
    t.string "eventTime", limit: 50
    t.string "roleID", limit: 50
  end

  create_table "EventCount", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode"
    t.string "statdate", limit: 20
    t.string "gameregion", limit: 10
    t.string "eventid", limit: 200
    t.integer "count"
    t.text "info", size: :medium
    t.integer "roleidcount"
  end

  create_table "Resource", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode"
    t.string "gameregion", limit: 50
    t.string "accountid", limit: 50
    t.string "playerid", limit: 50
    t.string "createtime", limit: 50
    t.string "resourceid", limit: 50
    t.string "num", limit: 50
    t.text "reason", size: :medium
    t.string "type", limit: 10
  end

  create_table "advertgameinfo", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "gamecode", limit: 20, default: "", null: false
    t.string "appid", limit: 200, default: "", null: false
  end

  create_table "channel_activeuser", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "chlcode"
    t.integer "gamecode"
    t.string "activeuser"
    t.string "statdate"
    t.string "loginthree"
  end

  create_table "channel_change_log", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "user_id", limit: 20
    t.datetime "change_time"
    t.integer "change_type"
    t.text "change_log"
  end

  create_table "channel_code_advert", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "code", limit: 20, collation: "utf8_general_ci"
    t.integer "game"
    t.datetime "time"
    t.float "advertcost", limit: 53, comment: "告费用广"
    t.string "remark", limit: 50, collation: "utf8_general_ci"
  end

  create_table "channel_code_info", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "link", limit: 10
    t.string "code", limit: 12
    t.string "id_code"
    t.string "mediasource"
    t.string "isjar", limit: 11
    t.string "balance_way"
    t.string "balance", limit: 11
    t.string "start_time"
    t.string "now_stat", limit: 11
    t.string "jar_tail"
    t.string "game"
    t.string "rate_fencheng", limit: 10
    t.integer "rate"
    t.string "remark"
    t.integer "is_account"
    t.string "account", limit: 20
    t.string "password", limit: 20
    t.string "scope", limit: 50
    t.integer "statday", default: 0
    t.string "category", limit: 11, default: "0", comment: "为 NULLl 或 0 都表示暂无类别"
    t.string "balance_way2", limit: 2
    t.string "stat_update_time", limit: 50, comment: "状态更改时间"
    t.integer "signed", default: 0
    t.integer "special_price", default: 0
    t.integer "reglevel", default: 0
    t.integer "regonlinetime", default: 0
    t.string "channel_name", comment: "渠道名称"
    t.string "channel_abbr", comment: "渠道简称"
    t.integer "userid", comment: "渠道负责人t_user用户id值"
    t.string "marketid", limit: 150, comment: "外部合作伙伴账户查看渠道代码"
    t.string "settle_date", limit: 50, comment: "沉默结算日期"
    t.integer "externalid", comment: "外部人员userid"
    t.index ["id_code"], name: "idx_id_code", unique: true
  end

  create_table "channel_code_info_bak", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "link", limit: 10
    t.string "code", limit: 12
    t.string "id_code"
    t.string "balance_way"
    t.integer "balance"
    t.string "now_stat", limit: 11
    t.string "statdate", limit: 25
    t.string "game"
    t.string "rate_fencheng", limit: 10
    t.integer "rate"
    t.integer "reglevel", default: 0
    t.integer "regonlinetime", default: 0
    t.index ["statdate", "game"], name: "idx_id"
  end

  create_table "channel_history", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "channel_id_code", limit: 20
    t.string "last_stat", limit: 2
    t.datetime "modify_date"
    t.integer "modify_user_id"
    t.string "what_is_more", limit: 100
  end

  create_table "channel_info", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "channel_name", limit: 50, default: ""
    t.string "id_code", limit: 20
    t.string "company_name", limit: 50
    t.integer "iswebunion", default: 0
    t.string "wap_address"
    t.string "contact_man", limit: 50
    t.string "contact_way", limit: 50
    t.integer "user_id"
    t.string "start_time", default: ""
    t.integer "now_stat"
    t.string "stat_update_time", limit: 50
    t.integer "isPersonal"
    t.string "remark", limit: 250
    t.float "taxation", limit: 53, comment: "账务耿波变更分成类合作公司个人营业税为税费百分比"
    t.string "company_abbr", comment: "公司简称"
    t.integer "operation_system", default: 0, comment: "操作系统android1IOS正版2IOS破解3"
    t.integer "balance_way", default: 4, comment: "作合模式注册1下载2分成3联运4"
    t.index ["id_code"], name: "idx_id_code", unique: true
  end

  create_table "channel_log_time", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "name", limit: 20
    t.string "id_code", limit: 10
    t.string "name_id_code", limit: 20
    t.datetime "log_time"
    t.string "code", limit: 8
    t.string "ip", limit: 20
    t.string "stat", limit: 10
  end

  create_table "channel_spend", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "game_code", limit: 3
    t.string "stat_date", limit: 20
    t.text "spand", size: :medium
  end

  create_table "channel_start", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "code", limit: 20, null: false
    t.integer "game", null: false
    t.string "startdate", limit: 20, null: false
  end

  create_table "channel_stat_desc", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "stat", limit: 10
    t.string "desc", limit: 20
  end

  create_table "channel_stat_user_bridge", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "userid"
    t.integer "channel_userid"
    t.integer "author", default: 0
    t.string "notice", limit: 100
  end

  create_table "channel_update_info", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "userid"
    t.integer "gameid"
    t.string "channelcode", limit: 50
    t.string "updatetime", limit: 50
    t.string "oldinfo", limit: 50
    t.string "newinfo", limit: 50
  end

  create_table "channel_user_info", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "user_id", default: 0
    t.string "user_name", limit: 20, default: "", null: false
    t.string "password", limit: 20, default: "", null: false
    t.string "name", limit: 20
    t.string "role", limit: 150, default: "0"
    t.string "remark", limit: 50, default: ""
    t.string "type", limit: 50
    t.string "id_code", limit: 20
    t.integer "is_validate", default: 0
    t.string "gamecodes", limit: 100
    t.string "work_stat", limit: 1, default: "1"
  end

  create_table "country_info", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "international", limit: 10
    t.string "country", limit: 100
    t.string "countries", limit: 50
  end

  create_table "exclude_account_info", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode", null: false
    t.integer "accountid"
    t.index ["accountid"], name: "idx"
  end

  create_table "gsinfo", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gameid", null: false
    t.integer "areaid", null: false
    t.string "accountid", limit: 30, null: false
    t.integer "playerid"
    t.datetime "timestamp", null: false
  end

  create_table "ios_reports", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode", comment: "数据平台游戏id"
    t.string "sku", comment: "appstore内部购买id"
    t.integer "units", comment: "购买次数"
    t.decimal "price", precision: 10, scale: 2, comment: "购买价格", unsigned: true
    t.decimal "price_cny", precision: 10, scale: 2, comment: "由title identifier中解析出来的值，相当于人民币价格（前题是游戏中传值正确）", unsigned: true
    t.date "date", null: false, comment: "购买日期"
    t.string "currency", limit: 10, comment: "币种"
    t.datetime "created_at", null: false, comment: "导出记录时间 utc"
  end

  create_table "ip_country", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "ip", limit: 15
    t.string "country", limit: 50
    t.string "province", limit: 50
    t.string "city", limit: 50
  end

  create_table "ip_province", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "IP", limit: 20, default: "", null: false
    t.string "province", limit: 50, default: "", null: false
    t.string "city", limit: 50
    t.index ["IP"], name: "idx_ip"
  end

  create_table "item_xml", id: :integer, charset: "gb2312", force: :cascade do |t|
    t.integer "gamecode"
    t.integer "itemid"
    t.string "itemcode"
    t.string "itemname"
    t.string "itemtype"
    t.time "createtime"
  end

  create_table "items_equipments_storage_count", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "gamesWitch", default: 0, null: false
    t.integer "gameRegion", default: 0, null: false
    t.string "statDate", limit: 50
    t.text "itemsStorage", size: :medium
    t.text "equipmentsStorage", size: :medium
  end

  create_table "payment_info", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "gamecode"
    t.string "paycode", limit: 30, collation: "utf8_general_ci"
    t.float "payrate", limit: 53, default: 0.0, comment: "通道费"
    t.float "taxrate", limit: 53, default: 0.0, comment: "税率"
    t.float "precentrate", limit: 53, default: 0.0, comment: "分成比例对方合同标注即对方的比例"
    t.string "payname", limit: 50, collation: "utf8_general_ci"
    t.integer "typecode"
    t.string "typename", limit: 50, collation: "utf8_general_ci"
    t.string "channel_income", limit: 50
    t.string "company", limit: 50
    t.string "cooperate", limit: 50
    t.string "username", limit: 50, comment: "商务负责人t_user用户id值"
    t.integer "status", default: 0, comment: "0：待确认，1：未合作，2：未签署，3：签署中，4：合作中"
    t.string "startdate", limit: 50, comment: "协议开始日期"
    t.string "enddate", limit: 50, comment: "协议结束日期"
    t.string "settledate", limit: 50, comment: "结算截止日期"
    t.string "info1", default: "合同备注"
    t.string "info"
  end

  create_table "payment_money", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "currency", limit: 20, comment: "币种"
    t.float "rmb", limit: 53, comment: "该币种兑换人民币比例,乘以该值得人民币单位分"
    t.string "name", limit: 50
    t.string "info"
  end

  create_table "pip_account_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.integer "gamecode", null: false
    t.integer "regionid"
    t.string "accgame", limit: 50, comment: "备注游戏id.（在player表中拿出来的accountid与account表中id所对应的游戏可能不是同一款游戏，在此做一个备注）"
    t.integer "accountid"
    t.string "name", limit: 200
    t.string "createtime", limit: 100
    t.string "ip", limit: 100
    t.string "province", limit: 100, comment: "地域"
    t.string "model", limit: 200
    t.string "clientmodel", limit: 100
    t.string "cid", limit: 300
    t.string "system", limit: 100, comment: "系统"
    t.string "version", limit: 100
    t.string "channel", limit: 50
    t.string "backversion", limit: 50
    t.string "backchannel", limit: 100
    t.string "state", limit: 10, comment: "状态1是新增账户，0不是新增账户"
    t.integer "stepnum"
    t.string "onlinetime", limit: 50
    t.integer "level1"
    t.integer "level2"
    t.integer "level3"
    t.integer "clevel1"
    t.integer "clevel2"
    t.integer "clevel3"
    t.string "adid", limit: 50, comment: "广告id"
    t.string "country", limit: 50, comment: "国家"
    t.string "attributedtouchtime", limit: 30, comment: "时间"
    t.string "platform", limit: 30
    t.index ["statdate", "backchannel"], name: "idx_statdate_backchannel"
    t.index ["statdate", "gamecode", "regionid", "accgame"], name: "idx"
    t.index ["statdate", "ip"], name: "idx_statdate_ip"
  end

  create_table "pip_account_model", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "modelinfo", limit: 200
    t.string "system", limit: 100
    t.string "name", limit: 100
    t.string "mark", limit: 100
    t.string "type", limit: 100
    t.string "model", limit: 100
  end

  create_table "pip_activation_model_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate"
    t.integer "gamecode"
    t.string "channel", limit: 100
    t.string "country", limit: 50
    t.text "cid", size: :medium
    t.integer "total"
    t.integer "day2count"
    t.integer "day3count"
    t.integer "day4count"
    t.integer "day5count"
    t.integer "day6count"
    t.integer "day7count"
    t.integer "day15count"
    t.integer "day30count"
    t.integer "day60count", comment: "第60天留存数即当天激活cid在第60天登录状况"
    t.integer "day8count"
    t.integer "day9count"
    t.integer "day10count"
    t.integer "day11count"
    t.integer "day12count"
    t.integer "day13count"
    t.integer "day14count"
    t.integer "day16count"
    t.integer "day17count"
    t.integer "day18count"
    t.integer "day19count"
    t.integer "day20count"
    t.integer "day21count"
    t.integer "day22count"
    t.integer "day23count"
    t.integer "day24count"
    t.integer "day25count"
    t.integer "day26count"
    t.integer "day27count"
    t.integer "day28count"
    t.integer "day29count"
  end

  create_table "pip_activegroup_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.string "gamecode", limit: 10
    t.string "channel", limit: 50
    t.string "system", limit: 50
    t.string "province", limit: 50
    t.string "count", limit: 50
  end

  create_table "pip_activelevel_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.integer "gamecode"
    t.integer "regionid"
    t.text "activelevel", size: :medium
  end

  create_table "pip_allproduct_data", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gameid"
    t.string "channel_name", limit: 50
    t.integer "type", comment: "0新增注册用户数,1活跃用户数,2上月新增本月留存用户数,3付费用户数,4收入总额-分成前,5收入总额-分成后"
    t.string "statdate", limit: 50
    t.float "count", limit: 53
  end

  create_table "pip_balance_info", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.integer "gamecode"
    t.string "partition", limit: 50
    t.string "regionid", limit: 10
    t.string "abalance", limit: 50
    t.string "bbalance", limit: 50
    t.integer "type"
  end

  create_table "pip_balance_info_bak", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.integer "gamecode"
    t.integer "regionid"
    t.integer "accountid"
    t.bigint "abalance"
    t.bigint "bbalance"
    t.index ["accountid", "abalance", "bbalance"], name: "id_balance"
    t.index ["statdate"], name: "date"
  end

  create_table "pip_bill_lianyun", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "payname", limit: 80
    t.string "paycode", limit: 50
    t.string "companyname", limit: 300
    t.integer "gamecode"
    t.string "month", limit: 10
    t.float "money1", limit: 53
    t.float "money2", limit: 53
    t.integer "billstate", default: 0, comment: "账单状态待确认0,正常提供1,不提供2,暂缓提供3"
    t.string "billstartdate", limit: 25, comment: "账单提供日期"
    t.string "billenddate", limit: 25, comment: "账单确认日期"
    t.float "billconfirmmoney", limit: 53, default: 0.0, comment: "确认结算金额"
    t.string "info", limit: 500, comment: "充值通道备注"
    t.integer "billstate2", default: 0, comment: "结算状态:0待确认1正常2暂缓"
    t.float "billmoney1", limit: 53, comment: "开票金额"
    t.float "billmoney2", limit: 53, comment: "实际金额"
    t.string "billnumber", limit: 50, comment: "发票号"
    t.string "billdate1", limit: 25, comment: "结算单提供日期"
    t.string "billdate2", limit: 25, comment: "开票日期"
    t.string "billdate3", limit: 25, comment: "寄票日期"
    t.string "trackingnumber", limit: 30, comment: "快递单号"
    t.string "billdate4", limit: 25, comment: "收款日期"
    t.string "info2", limit: 500, comment: "开票备注"
    t.integer "billstate3", comment: "收款状态"
    t.integer "daynum", comment: "持续天数"
    t.index ["paycode", "gamecode", "month"], name: "index_key", unique: true
  end

  create_table "pip_consume_info_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode", comment: "游戏ID"
    t.string "statdate", limit: 50, comment: "消费日期"
    t.string "accountid", limit: 50, comment: "账户ID"
    t.float "amountfree", limit: 53, comment: "消耗元宝"
    t.float "amountpay", limit: 53, comment: "消耗充值元宝"
    t.float "money", limit: 53, comment: "消耗充值金额"
    t.string "paychannel", limit: 50, comment: "消耗充值金额所属支付通道"
  end

  create_table "pip_country_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode"
    t.string "country", limit: 50
  end

  create_table "pip_event_info", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode"
    t.string "createtime", limit: 50
    t.string "eventid", limit: 10
    t.string "eventname", limit: 200
    t.integer "showstate"
    t.text "info", size: :medium
  end

  create_table "pip_income_month", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 20
    t.integer "gamecode"
    t.string "money1", limit: 50, comment: "成前收入分"
    t.string "money2", limit: 50, comment: "成后收入分"
    t.string "acctotal", limit: 50
    t.string "activenum", limit: 50
    t.string "accountnum", limit: 50, comment: "新增账户数"
    t.string "feenum", limit: 50, comment: "付费账户数"
    t.string "newfeenum", limit: 50, comment: "新增付费账户数"
    t.integer "newmoney", comment: "新增付费账户收入"
    t.integer "newaccountmoney", comment: "新增账户收入"
    t.string "goldconsume", limit: 50
  end

  create_table "pip_income_sure", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode"
    t.string "statmonth", limit: 50
    t.float "billmoney", limit: 53, comment: "开票金额"
    t.string "billnum", limit: 50, comment: "发票号"
    t.string "billdate", limit: 50, comment: "发票日期"
    t.float "realmoney", limit: 53, comment: "实际收款金额"
    t.string "realdate", limit: 50, comment: "实际收款日期"
    t.string "companycode", limit: 50
    t.string "companyname", limit: 300
    t.string "info", limit: 500
  end

  create_table "pip_income_yuanbao", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode"
    t.string "statdate", limit: 50
    t.integer "money"
    t.integer "money1"
    t.integer "money2"
    t.integer "imoney180d"
    t.integer "imoney180d1", comment: "imoney180d除以360换成分"
    t.integer "imoney180d2"
    t.string "statdate180d", limit: 50
    t.integer "type", comment: "1代表官网2代表联运"
    t.integer "ibuyMoneyUnknown", comment: "未知通道元宝消费"
    t.index ["gamecode", "statdate"], name: "id_game_statdate"
  end

  create_table "pip_incomegroup_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.string "registerchannel", limit: 50
    t.string "paychannel", limit: 50
    t.string "gamecode", limit: 10
    t.string "gameregion", limit: 50
    t.string "province", limit: 50
    t.string "phonesys", limit: 50
    t.string "money1", limit: 50, comment: "分组综合（分成前）"
    t.string "money2", limit: 50, comment: "分组综合（分成后）"
    t.integer "regionid"
  end

  create_table "pip_itemconsume_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.integer "gamecode"
    t.integer "regionid"
    t.string "goldByCharge", limit: 50
    t.string "goldByGame", limit: 50
    t.string "goldConsume", limit: 50
    t.text "itemInfo", size: :medium
  end

  create_table "pip_outflow_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.string "gamecode", limit: 10
    t.text "outflow7areanum", size: :medium
    t.text "outflow7systemnum", size: :medium
    t.text "outflow14areanum", size: :medium
    t.text "outflow14systemnum", size: :medium
    t.text "outflow30areanum", size: :medium
    t.text "outflow30systemnum", size: :medium
  end

  create_table "pip_payaccount_info_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode", comment: "游戏ID"
    t.string "createtime", limit: 50, comment: "账户在游戏首次登录时间"
    t.string "accountid", limit: 50, comment: "账户ID"
    t.string "regcid", limit: 50, comment: "账户注册设备ID"
    t.string "regip", limit: 50, comment: "账户注册IP"
    t.string "regprovince", limit: 50, comment: "账户注册IP所属地域"
  end

  create_table "pip_province_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "city", limit: 50
    t.string "province", limit: 50
  end

  create_table "pip_quarter", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "quarter", limit: 20
    t.integer "gamecode"
    t.integer "acctotal"
    t.integer "money1"
    t.integer "money2"
    t.integer "activenum"
    t.integer "feenum"
  end

  create_table "pip_quest_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.integer "gamecode"
    t.string "regionid", limit: 20
    t.string "questid", limit: 20
    t.integer "getquestnum"
    t.integer "abandonnum", comment: "放弃任务次数"
    t.integer "finishquestnum"
  end

  create_table "pip_resource_count", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.string "gamecode", limit: 50
    t.string "regionid", limit: 50
    t.string "resourceid", limit: 100
    t.string "count", limit: 100
    t.string "createtime", limit: 200
    t.text "accountinfo", size: :medium
    t.text "reasoninfo", size: :medium
    t.string "type", limit: 10
  end

  create_table "pip_stepname_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gameid", null: false
    t.integer "action"
    t.string "stepname", limit: 200
    t.integer "position"
    t.integer "type"
    t.string "version", limit: 20, comment: "版本"
    t.string "platform", limit: 20, comment: "平台"
  end

  create_table "resource_info", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode"
    t.string "resourceid", limit: 50
    t.string "resourcename", limit: 50
    t.string "createtime", limit: 50
    t.integer "showstate"
    t.string "info", limit: 50
  end

  create_table "stat_accountdata_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "gameswitch", default: 0, null: false
    t.string "statdate", limit: 50
    t.integer "regnum"
    t.integer "adduser"
    t.integer "leaveuser"
    t.text "model", size: :medium
    t.text "version", size: :medium
    t.text "loguser", size: :medium
    t.integer "reguser"
    t.integer "activeuser"
    t.integer "regandpayuser"
    t.index ["statdate"], name: "date"
  end

  create_table "stat_activation_channel_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate"
    t.integer "gamecode"
    t.string "chlcode", limit: 30
    t.string "country", limit: 50
    t.text "chlinfo", size: :medium
    t.integer "total"
    t.integer "newaccount", comment: "2014-07-03添加新增账户列"
    t.integer "day2count"
    t.integer "day3count"
    t.integer "day4count"
    t.integer "day5count"
    t.integer "day6count"
    t.integer "day7count"
    t.integer "day15count"
    t.integer "day30count"
    t.integer "day60count", comment: "第60天留存数即当天激活cid在第60天登录状况"
    t.integer "day8count"
    t.integer "day9count"
    t.integer "day10count"
    t.integer "day11count"
    t.integer "day12count"
    t.integer "day13count"
    t.integer "day14count"
    t.integer "day16count"
    t.integer "day17count"
    t.integer "day18count"
    t.integer "day19count"
    t.integer "day20count"
    t.integer "day21count"
    t.integer "day22count"
    t.integer "day23count"
    t.integer "day24count"
    t.integer "day25count"
    t.integer "day26count"
    t.integer "day27count"
    t.integer "day28count"
    t.integer "day29count"
    t.index ["day2count", "day3count", "day4count", "day5count", "day6count", "day7count", "day15count", "day8count", "day9count", "day10count", "day11count", "day12count", "day13count", "day14count"], name: "gamecode,statdate,chlcode"
  end

  create_table "stat_activation_cid", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode"
    t.string "statdate", limit: 25
    t.integer "regioncode"
    t.string "gameregion", limit: 50
    t.datetime "createtime"
    t.integer "accountid"
    t.string "cid", limit: 100
    t.string "chlcode", limit: 25
    t.string "clientmodel"
    t.string "model"
    t.string "serviceversion", limit: 100
    t.index ["gamecode", "statdate"], name: "index"
  end

  create_table "stat_activation_player_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 25
    t.integer "gamecode"
    t.integer "gameregion"
    t.integer "accountid"
    t.integer "playerid"
    t.datetime "createtime"
    t.string "playername"
    t.integer "xx"
    t.integer "yy"
    t.integer "level"
    t.datetime "lastlogintime"
    t.string "chlcode", limit: 25
    t.string "cid", limit: 100
    t.string "accountname", limit: 100
    t.integer "faction"
    t.index ["statdate", "gamecode"], name: "statdate_gamecode"
  end

  create_table "stat_active_fee_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 25
    t.integer "gamecode"
    t.integer "activenum"
    t.text "activeinfo", size: :medium
    t.integer "feenum"
    t.integer "feemoney"
    t.integer "loyalnum"
    t.text "feeinfo", size: :medium
    t.text "moneyinfo", size: :medium
    t.text "chargedayinfo", size: :medium
    t.text "chargemoneyinfo", size: :medium
    t.text "chargelevelinfo", size: :medium
    t.text "activedayinfo", size: :medium
    t.text "lianyuninfo", size: :medium, comment: "联运渠道使用联运充值通道的数据值格式渠道%人数%订单%金额"
    t.text "firstpayinfo", size: :medium, comment: "首次付费：渠道代码%人数%金额"
    t.integer "clientnum", comment: "启动客户端数"
    t.text "clientinfo", size: :medium, comment: "启动客户端数：渠道%启动数"
    t.text "loginusertime", size: :medium, comment: "当天活跃用户登录人数与在线时长"
    t.text "firstusertime", size: :medium, comment: "激活用户登录人数与在线时长"
  end

  create_table "stat_average_high_online_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "gamecode", null: false
    t.string "statdate", limit: 50
    t.integer "aveonline"
    t.integer "highonline"
  end

  create_table "stat_center", id: { type: :string, limit: 50, default: "" }, charset: "utf8", force: :cascade do |t|
    t.string "name", limit: 100
    t.integer "status", limit: 1
    t.string "content", limit: 500
    t.string "ip", limit: 100
    t.string "username", limit: 100
    t.string "password", limit: 100
    t.string "gamecode", limit: 100
    t.string "regioncode", limit: 100
    t.string "createtime", limit: 100
    t.string "modifytime", limit: 100
    t.string "owner", limit: 100
    t.integer "type", limit: 1
  end

  create_table "stat_channelfee_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "channel", limit: 50
    t.integer "gameswitch", default: 0, null: false
    t.string "statdate", limit: 50
    t.text "model", size: :medium
    t.text "income", size: :medium
    t.integer "money1", comment: "分成前"
    t.integer "money2", comment: "分成后"
  end

  create_table "stat_channelreg_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "gameswitch", default: 0, null: false
    t.string "statdate", limit: 50
    t.text "regdata", size: :medium
    t.text "regdatanew", size: :medium
  end

  create_table "stat_clientmodel_common", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "gamecode", default: 0, null: false
    t.string "statdate", limit: 50, null: false
    t.integer "action"
    t.string "version"
    t.integer "lognum"
    t.string "model"
    t.text "loginfo", size: :medium
    t.string "channel"
    t.index ["statdate", "gamecode"], name: "idx_stat_userstay_common"
  end

  create_table "stat_clientmodel_common_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.integer "gamecode"
    t.string "cid", limit: 200
    t.string "createtime", limit: 50
    t.string "channel", limit: 50
    t.string "model", limit: 50
    t.string "version", limit: 50
    t.string "country", limit: 50
    t.integer "day1"
    t.integer "day2"
    t.integer "day3"
    t.string "ip", limit: 50
    t.string "position1", limit: 50
    t.string "position2", limit: 50
    t.string "position3", limit: 50
    t.index ["gamecode", "createtime", "cid"], name: "gamecode"
  end

  create_table "stat_customerloyalty_month", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "month", limit: 7, null: false
    t.string "game_code", limit: 10, null: false
    t.text "customerloyalty", size: :medium, null: false, comment: "用户ID%登陆次数%在线时长%最高角色级别;"
    t.integer "lostUserAmount"
    t.string "lostUserRate", limit: 10
    t.integer "onlineUserAmount"
    t.integer "lastMonthUserAmount"
    t.text "levelUserCharge", size: :medium
  end

  create_table "stat_customerloyalty_week", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "start_date", limit: 10, null: false
    t.string "end_date", limit: 10, null: false
    t.string "game_code", limit: 10, null: false
    t.text "customerloyalty", size: :medium, null: false
    t.integer "lostUserAmount"
    t.string "lostUserRate", limit: 10
    t.integer "onlineUserAmount"
    t.integer "lastWeekUserAmount"
    t.text "levelUserCharge", size: :medium
  end

  create_table "stat_event", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.integer "gamecode"
    t.integer "gameregion"
    t.string "eventid", limit: 50
    t.string "eventkey", limit: 50
    t.string "eventvalue", limit: 100
    t.integer "eventcount"
    t.integer "eventuser"
  end

  create_table "stat_forbinfo_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.integer "gameswitch"
    t.integer "gameregion"
    t.text "forbinfo", size: :medium
  end

  create_table "stat_income3_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.integer "gamecode", default: 0, null: false
    t.string "channel", limit: 50
    t.decimal "amount", precision: 10
    t.decimal "amount1", precision: 10, comment: "分成后-按合作方"
    t.decimal "amount2", precision: 10
  end

  create_table "stat_incomeImoney_gs", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gameid"
    t.integer "gameregion"
    t.integer "accountid"
    t.integer "playerid"
    t.integer "imoney"
    t.datetime "datehour"
  end

  create_table "stat_incomeImoney_hour", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "game", limit: 2
    t.string "gameregion", limit: 13
    t.string "datehour", limit: 13
    t.bigint "imoney"
  end

  create_table "stat_income_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "channel", limit: 50
    t.integer "gameswitch", default: 0, null: false
    t.string "statdate", limit: 50
    t.text "income", size: :medium
  end

  create_table "stat_income_info_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode"
    t.string "statdate", limit: 25, collation: "gbk_chinese_ci"
    t.datetime "finishtime"
    t.string "paychannel", collation: "gbk_chinese_ci"
    t.integer "money1"
    t.integer "money2"
    t.string "accountid", limit: 25, collation: "gbk_chinese_ci"
    t.string "regioncode", limit: 25, collation: "gbk_chinese_ci"
    t.string "productid", limit: 25, collation: "gbk_chinese_ci"
    t.string "orderid", limit: 25, collation: "gbk_chinese_ci"
    t.string "playerid", limit: 25, collation: "gbk_chinese_ci"
    t.string "playername", limit: 25
    t.string "level", limit: 25, collation: "gbk_chinese_ci"
    t.string "phonesys", collation: "gbk_chinese_ci"
    t.string "regionid", limit: 5, collation: "gbk_chinese_ci"
    t.string "money", limit: 11, collation: "gbk_chinese_ci"
    t.string "currency", limit: 20, collation: "gbk_chinese_ci"
    t.float "rmb", limit: 53, comment: "该币种兑换人民币比例,乘以该值得人民币单位分"
    t.string "amount", limit: 50, collation: "gbk_chinese_ci"
    t.index ["gamecode", "finishtime", "accountid"], name: "incex_game_finishtime_accountid"
    t.index ["gamecode", "statdate"], name: "index_game_statdate"
  end

  create_table "stat_income_regtime_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "statdate", limit: 25
    t.integer "gamecode"
    t.text "regtimemoney", size: :medium, comment: "每天充值玩家最早创建角色时间"
  end

  create_table "stat_income_sum_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "gamecode"
    t.string "statdate", limit: 25
    t.datetime "createtime"
    t.datetime "finishtime"
    t.string "registerchannel"
    t.string "paychannel"
    t.integer "money1"
    t.integer "money2"
    t.integer "accountid"
    t.string "regioncode", limit: 25
    t.string "name"
    t.string "phonesys"
    t.string "phoneclient", limit: 155
    t.string "province", limit: 50
    t.string "firstcharge", limit: 10, comment: "如果是首充标记为1"
    t.string "firstchargemoney", limit: 11
    t.datetime "lastlogintime"
    t.integer "regionid"
    t.integer "money"
    t.string "currency", limit: 20
    t.float "rmb", limit: 53, comment: "该币种兑换人民币比例,乘以该值得人民币单位分"
    t.string "amount", limit: 50
    t.index ["gamecode", "finishtime", "accountid"], name: "incex_game_finishtime_accountid"
    t.index ["gamecode", "statdate"], name: "index_game_statdate"
  end

  create_table "stat_incomefee_hour", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "game", limit: 10
    t.integer "regionid"
    t.string "datehour", limit: 13
    t.integer "fee"
  end

  create_table "stat_outflow_day", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode"
    t.string "statdate", limit: 25
    t.integer "login7num", comment: "7天前登录账户数"
    t.integer "login7feenum"
    t.integer "outflow7num", comment: "7天未登录账户数"
    t.text "outflow7channel", size: :medium, comment: "7天流失用户注册渠道"
    t.text "outflow7register", size: :medium, comment: "7天流失户用最早注册时间"
    t.text "outflow7level", size: :medium, comment: "7天流失户用最大角色级别"
    t.text "outflow7feetotal", size: :medium, comment: "7天付费金额大于多少的流失数"
    t.text "outflow7feenum", size: :medium, comment: "7天付费次数大于多少的流失用户"
    t.text "outflow7areanum", size: :medium
    t.string "outflow7systemnum", limit: 200
    t.integer "login14num", comment: "14天前登录账户数"
    t.integer "login14feenum"
    t.integer "outflow14num", comment: "14天未登录账户数"
    t.text "outflow14channel", size: :medium, comment: "14天流失用户注册渠道"
    t.text "outflow14register", size: :medium, comment: "14天流失户用最早注册时间"
    t.text "outflow14level", size: :medium, comment: "14天流失户用最大角色级别"
    t.text "outflow14feetotal", size: :medium, comment: "14天付费金额大于多少的流失数"
    t.text "outflow14feenum", size: :medium, comment: "14天付费次数大于多少的流失用户"
    t.text "outflow14areanum", size: :medium
    t.string "outflow14systemnum", limit: 200
    t.integer "login30num", comment: "30天前登录账户数"
    t.integer "login30feenum"
    t.integer "outflow30num", comment: "30天未登录账户数"
    t.text "outflow30channel", size: :medium, comment: "30天流失用户注册渠道"
    t.text "outflow30register", size: :medium, comment: "30天流失户用最早注册时间"
    t.text "outflow30level", size: :medium, comment: "30天流失户用最大角色级别"
    t.text "outflow30feetotal", size: :medium, comment: "30天付费金额大于多少的流失数"
    t.text "outflow30feenum", size: :medium, comment: "30天付费次数大于多少的流失用户"
    t.text "outflow30areanum", size: :medium
    t.string "outflow30systemnum", limit: 200
    t.text "outflow7clevel", size: :medium, comment: "7天流失户用最大城堡级别，cot专用"
    t.text "outflow14clevel", size: :medium, comment: "14天流失户用最大城堡级别，cot专用"
    t.text "outflow30clevel", size: :medium, comment: "30天流失户用最大城堡级别，cot专用"
    t.index ["gamecode", "statdate"], name: "index_ins"
  end

  create_table "stat_roleattr_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.integer "gameswitch"
    t.integer "gameregion"
    t.text "roleattr", size: :medium
  end

  create_table "stat_roledata_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "stat_date", limit: 10
    t.integer "game_code"
    t.integer "game_region"
    t.text "role_level_number", size: :medium
    t.text "tong_rank_tophandred", size: :medium
    t.text "role_charge_tophandred", size: :medium
    t.text "role_clazz_number"
    t.text "role_faction_number"
    t.text "role_camp_number"
  end

  create_table "stat_searchcharge_info_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "user", limit: 50, null: false
    t.string "gamecode", limit: 50
    t.string "region", limit: 50
    t.string "money", limit: 50
    t.string "createtime", limit: 100
    t.string "searchtime", limit: 100
    t.string "feeway", limit: 100
    t.string "channel", limit: 50
    t.string "showCreateTime", limit: 50
    t.string "showFirstCharge", limit: 50
    t.string "collectORdetail", limit: 50
    t.string "itemname", limit: 100
    t.string "playerid", limit: 50
    t.string "keyword", limit: 50
    t.string "reporttype", limit: 50
  end

  create_table "stat_shell", id: { type: :string, limit: 50, default: "" }, charset: "utf8", force: :cascade do |t|
    t.string "skey", limit: 100
    t.string "name", limit: 100
    t.integer "status"
    t.string "content", limit: 500
    t.string "location", limit: 50
    t.string "ip", limit: 100
    t.string "username", limit: 100
    t.string "password", limit: 100
    t.string "gamecode", limit: 100
    t.string "regioncode", limit: 100
  end

  create_table "stat_user_active_lost", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "month_number"
    t.string "start_date", limit: 10
    t.string "end_date", limit: 10
    t.integer "game_code"
    t.integer "active_user_num"
    t.integer "lost_user_num"
  end

  create_table "stat_useractive_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "statdate", limit: 10
    t.integer "gameswitch", default: 0, null: false
    t.string "country", limit: 50, comment: "国家"
    t.text "days30channelfee", size: :medium
    t.integer "validactiveuser", default: 0, null: false
    t.integer "transuser", default: 0, null: false
    t.text "loguseridlevel", size: :medium
    t.integer "days1feeusernum"
    t.integer "days1totalfee"
    t.text "days1channeluserfee", size: :medium
    t.integer "days7feeusernum", default: 0, comment: "新建用户7日内付费转化率"
    t.integer "days7totalfee"
    t.text "days7channeluserfee", size: :medium
    t.integer "days14feeusernum"
    t.integer "days14totalfee", default: 0, comment: "当天创建账户后7天内付费用户数"
    t.text "days14channeluserfee", size: :medium
    t.integer "days30feeusernum"
    t.integer "days30totalfee", default: 0, comment: "当天创建账户后30天内总付费额"
    t.text "days30channeluserfee", size: :medium, comment: "渠道代码%付费用户数%付费金额"
    t.text "firstchanneluserfee", size: :medium, comment: "渠道代码%付费用户数%付费金额"
    t.text "currentdaylogactiveuser", size: :medium, comment: "渠道%活跃用户数"
    t.text "currentdaypayuser", size: :medium, comment: "渠道%付费用户数"
    t.text "days30lianyunchannelfee", size: :medium, comment: "30天内联运渠道%分成前%分成后"
    t.text "days7channeloutflow", size: :medium
    t.index ["statdate", "gameswitch"], name: "idx_stat_useractive_day"
  end

  create_table "stat_usercharge", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "game_code"
    t.string "charge_date", limit: 10
    t.text "userid_charge", size: :medium
    t.integer "user_charge_count"
    t.integer "charge_count"
    t.text "fresh_user_charge_channel", size: :medium
    t.integer "fresh_user_charge_count"
    t.text "time_share_charge", size: :medium
    t.index ["charge_date"], name: "idx_charge_date"
  end

  create_table "stat_userdata_day", id: :integer, charset: "gbk", options: "ENGINE=InnoDB ROW_FORMAT=COMPRESSED", force: :cascade do |t|
    t.integer "gameswitch", default: 0, null: false
    t.integer "gameregion", default: 0, null: false
    t.string "statdate", limit: 10
    t.integer "highonlinenum", default: 0, null: false
    t.text "pointtimeonline", size: :medium
    t.integer "activeuser"
    t.integer "loginnum"
    t.integer "addrole"
    t.text "loguserid", size: :medium
    t.text "logroleid", size: :medium
    t.integer "leaveusernum"
    t.integer "leaverolenum"
    t.text "versionlog", size: :medium
    t.text "versionlogcount", size: :medium
    t.text "modellog", size: :medium
    t.text "modellogcount", size: :medium
    t.integer "onlineavg"
    t.string "useronlinetime"
    t.text "leveluptop100", size: :medium
    t.text "moneytop100", size: :medium
    t.text "imoney", size: :medium
    t.text "idimoney", size: :medium
    t.text "levelimoney", size: :medium
    t.text "roleattribute", size: :medium
    t.text "moneytop100true", size: :medium
    t.text "idimoney2", size: :medium
    t.integer "avgonlinenum", default: 0
    t.index ["gameswitch", "statdate", "gameregion"], name: "idx_stat_userdata_day", unique: true
  end

  create_table "stat_wulin25_occupation_party", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "stat_date", limit: 10
    t.integer "game_region"
    t.string "occupation", limit: 100
    t.string "party", limit: 100
  end

  create_table "sys_config", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "cname", limit: 100
    t.string "cvalue", limit: 100
    t.string "note"
    t.integer "location"
  end

  create_table "sys_dict", id: { type: :string, limit: 50, default: "" }, charset: "utf8", force: :cascade do |t|
    t.string "dkey", limit: 100
    t.string "dval", limit: 100
    t.string "txt", limit: 100
    t.integer "status", limit: 1
    t.integer "location"
  end

  create_table "sys_resource", id: { type: :string, limit: 100, default: "" }, charset: "utf8", force: :cascade do |t|
    t.string "name", limit: 50
    t.string "url", limit: 100
    t.integer "state", limit: 1
    t.integer "subtype"
    t.integer "location"
    t.string "descript"
    t.string "button", limit: 1000
    t.string "style", limit: 20
  end

  create_table "sys_role", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "name", limit: 50
    t.string "unitid", limit: 50
    t.string "descript", limit: 50
    t.integer "pid"
    t.integer "location"
  end

  create_table "sys_role_resource", id: false, charset: "utf8", force: :cascade do |t|
    t.integer "roleid"
    t.string "resourceid", limit: 100
    t.string "button", limit: 1000
    t.index ["roleid", "resourceid"], name: "INDEX_ROLERESOURCE", unique: true
  end

  create_table "sys_safeconfig", id: :integer, default: 0, charset: "utf8", force: :cascade do |t|
    t.integer "type"
    t.integer "state"
    t.string "note", limit: 500
  end

  create_table "sys_task", primary_key: "task_id", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "task_code", limit: 100
    t.integer "task_type"
    t.string "task_name", limit: 50
    t.string "job_class", limit: 100
    t.integer "execycle"
    t.integer "day_of_month"
    t.integer "day_of_week"
    t.integer "hour"
    t.integer "minute"
    t.integer "interval_hour"
    t.integer "interval_minute"
    t.integer "task_interval_unit"
    t.string "cron_expression", limit: 20
    t.integer "is_enable"
    t.string "task_remark"
    t.bigint "user_id"
    t.string "create_time", limit: 50
    t.string "param_value", limit: 100
    t.integer "task_interval"
    t.integer "task_threadnum"
  end

  create_table "sys_unit", id: { type: :string, limit: 100, default: "" }, charset: "utf8", force: :cascade do |t|
    t.string "name", limit: 100
    t.string "unitcode", limit: 20
    t.string "descript"
    t.string "address", limit: 100
    t.string "telephone", limit: 20
    t.string "email", limit: 100
    t.string "website", limit: 100
    t.integer "location"
  end

  create_table "sys_user", charset: "utf8", force: :cascade do |t|
    t.string "loginname", limit: 120
    t.string "realname", limit: 100
    t.string "unitid", limit: 100
    t.string "password", limit: 50
    t.string "salt", limit: 50
    t.integer "state", limit: 1
    t.string "descript"
    t.string "position", limit: 100
    t.string "address", limit: 100
    t.string "telephone", limit: 20
    t.string "mobile", limit: 11
    t.string "email", limit: 120
    t.integer "location"
    t.string "style", limit: 20
    t.integer "logintype"
    t.string "logintime", limit: 20
    t.string "loginip", limit: 50
    t.integer "logincount"
    t.string "loginresid", limit: 100
    t.string "linkqq", limit: 20
    t.string "linkweb", limit: 100
    t.string "linkcity", limit: 100
    t.index ["loginname"], name: "INDEX_LONGINNAME"
  end

  create_table "sys_user_log", charset: "utf8", force: :cascade do |t|
    t.bigint "userid"
    t.integer "type"
    t.string "loginname", limit: 100
    t.string "realname", limit: 100
    t.string "note", limit: 100
    t.string "logintime", limit: 20
    t.string "loginip"
  end

  create_table "sys_user_role", id: false, charset: "utf8", force: :cascade do |t|
    t.bigint "userid"
    t.integer "roleid"
    t.index ["userid", "roleid"], name: "INDEX_USERROLE", unique: true
  end

  create_table "t_day_itemUsed", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "gameId", default: 0, null: false
    t.string "statdate", limit: 10
    t.integer "regionId", default: 0, null: false
    t.string "propsCode", limit: 30
    t.integer "usedAmount"
  end

  create_table "t_moneytop100_day", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "gameCode", default: 0, null: false
    t.integer "gameRegion", default: 0, null: false
    t.string "statDate", limit: 10
    t.text "moneyTop100", size: :medium
    t.index ["gameCode", "statDate", "gameRegion"], name: "idx_t_moneytop100_day", unique: true
  end

  create_table "t_month_userChannelInfo", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "statDate", limit: 7
    t.string "statDateDisplay", limit: 10
    t.integer "gameSwitch"
    t.string "channelCode", limit: 10, default: "", null: false
    t.string "channelName", limit: 50, default: ""
    t.integer "registerCount"
    t.index ["gameSwitch"], name: "idx_gameswitch"
    t.index ["statDate"], name: "idx_statdate"
  end

  create_table "t_month_userLost", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "gameswitch", default: 0, null: false
    t.integer "gameregion", default: 0, null: false
    t.string "statdate", limit: 10
    t.text "lostUserByLevel"
    t.text "rebackUserByLevel"
    t.text "activeUserBylevel"
  end

  create_table "t_report", id: :integer, charset: "gbk", collation: "gbk_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "report", null: false
    t.string "method", null: false
    t.integer "reportGroupId", null: false
    t.string "searchLevel"
    t.string "gameCodes"
    t.integer "waitTime", default: 0, comment: "该报表加载时间,单位:毫秒"
    t.integer "level", null: false, comment: "2:普通,1:高级,0:高级与普通具有"
    t.integer "orderNum", null: false
  end

  create_table "t_report_log", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "userId", null: false
    t.integer "reportId", null: false
    t.string "method"
    t.string "createTime", limit: 50, null: false
    t.integer "status", null: false
  end

  create_table "t_week_userLost", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "gameId", default: 0, null: false
    t.string "monday", limit: 10
    t.string "sunday", limit: 10
    t.integer "onlineUserAmount"
    t.integer "lastWeekUserAmount"
    t.integer "lostUserAmount"
    t.string "lostUserRate", limit: 10
  end

  create_table "tbl_advert_info", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "account_id", limit: 20, comment: "账户id"
    t.string "statdate", limit: 20, comment: "日期"
    t.string "date_start", limit: 20, comment: "开始日期"
    t.string "date_stop", limit: 20, comment: "结束日期"
    t.string "system", limit: 20, comment: "系统"
    t.string "platform", limit: 20, comment: "投放平台"
    t.string "mediasource", limit: 20, comment: "广告来源"
    t.string "campaignid", limit: 20, comment: "广告系列id"
    t.string "campaignname", limit: 200, comment: "广告系列名称"
    t.string "adgroupid", limit: 20, comment: "广告组id"
    t.string "adgroupname", limit: 20, comment: "广告组名称"
    t.string "adid", limit: 20, comment: "广告id"
    t.string "adname", limit: 20, comment: "广告名称"
    t.string "appid", limit: 20, comment: "产品id"
    t.string "appname", limit: 20, comment: "产品名称"
    t.string "country", limit: 10, comment: "国家"
    t.string "cost", limit: 20, comment: "花费"
    t.string "currency", limit: 20, comment: "币种"
    t.string "clicks", limit: 20, comment: "点击数"
    t.string "impressions", limit: 20, comment: "展示"
    t.string "covers", limit: 20, comment: "覆盖人数"
    t.string "installs", limit: 20, comment: "安装数量"
    t.string "creativeid", limit: 20, comment: "创意id"
    t.string "creativename", limit: 20, comment: "创意名称"
    t.string "imageid", limit: 50, comment: "图片编号"
    t.string "imagename", limit: 50, comment: "图片名称"
    t.string "imagesize", limit: 50, comment: "图片规格"
    t.string "imagelocationtype", limit: 20, comment: "图片位置类型"
    t.string "imageurl", limit: 200, comment: "图片url"
    t.index ["statdate", "campaignname"], name: "index_online3"
    t.index ["statdate", "country"], name: "index_online"
    t.index ["statdate", "platform"], name: "index_online2"
    t.index ["statdate", "system"], name: "index_online1"
  end

  create_table "tbl_monthuserinfo", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "statdate", limit: 50
    t.integer "gameswitch"
    t.integer "gameregion"
    t.integer "monthactiveuser", default: 0
    t.integer "monthfeeuser", default: 0
    t.integer "monthadduser", default: 0
    t.integer "monthleaveuser", default: 0
    t.integer "apa"
    t.integer "apa_0"
    t.integer "acu"
    t.integer "pcu"
    t.integer "monthMoney"
  end

  create_table "tbl_putlist", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode", comment: "游戏"
    t.string "startdate", limit: 30, comment: "开始日期"
    t.string "enddate", limit: 30, comment: "结束日期"
    t.string "platform", limit: 50, comment: "投放平台"
    t.string "country", limit: 50
    t.string "system", limit: 50
    t.string "createtime", limit: 100, comment: "创建日期"
    t.float "money", limit: 53, default: 0.0, comment: "通道费"
  end

  create_table "tbl_realtimeactive", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gameid"
    t.integer "areaid"
    t.string "channel", limit: 50
    t.string "version", limit: 50
    t.string "model", limit: 200
    t.string "time", limit: 200
    t.integer "num"
    t.string "regioncode", limit: 25
    t.index ["gameid", "channel", "version", "model", "time", "regioncode"], name: "all_index"
  end

  create_table "tbl_realtimechannel", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode", comment: "游戏ID"
    t.string "statdate", limit: 20, comment: "统计日期"
    t.string "channelcode", limit: 20, comment: "道渠代码"
    t.string "activenum", limit: 10, comment: "跃活账户"
    t.string "feenum", limit: 10, comment: "付费账户"
    t.string "newfeenum", limit: 10, comment: "当日新付费玩家数量"
    t.string "accountnum", limit: 10, comment: "新增账户"
    t.string "money", limit: 20, comment: "费付金额"
    t.string "newmoney", limit: 20, comment: "增新账户付费金额"
    t.string "country", limit: 20, comment: "家国"
    t.string "time", limit: 20, comment: "数据所在小时（24小时）"
    t.index ["gamecode", "country"], name: "index_online"
    t.index ["statdate", "gamecode"], name: "index_online1"
  end

  create_table "tbl_realtimechannelarea", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode", comment: "游戏ID"
    t.string "partition", limit: 50, comment: "分区"
    t.string "statdate", limit: 20, comment: "统计日期"
    t.string "channelcode", limit: 20, comment: "道渠代码"
    t.string "activenum", limit: 10, comment: "跃活账户"
    t.string "newactivenum", limit: 10, comment: "昨日新增账户活跃"
    t.string "feenum", limit: 10, comment: "付费账户"
    t.string "newfeenum", limit: 10, comment: "当日新付费玩家数量"
    t.string "accountnum", limit: 10, comment: "新增账户"
    t.string "money", limit: 20, comment: "费付金额"
    t.string "newmoney", limit: 20, comment: "增新账户付费金额"
    t.string "country", limit: 20, comment: "家国"
    t.string "time", limit: 20, comment: "数据所在小时（24小时）"
    t.index ["gamecode", "country"], name: "index_online"
    t.index ["statdate", "gamecode"], name: "index_online1"
  end

  create_table "tbl_realtimefee", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gameid"
    t.integer "areaid"
    t.string "channel_fee", limit: 100
    t.string "channel_reg", limit: 100
    t.integer "money"
    t.string "time", limit: 50
    t.string "model", limit: 100
    t.string "regioncode", limit: 25
    t.index ["gameid", "channel_fee", "channel_reg", "time", "model", "regioncode"], name: "index_fee"
  end

  create_table "tbl_realtimeonline", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gameid"
    t.integer "areaid"
    t.string "time", limit: 20
    t.integer "num"
    t.string "regioncode", limit: 50
    t.index ["gameid", "areaid", "time"], name: "index_online"
  end

  create_table "tbl_realtimereg", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gameid"
    t.integer "areaid"
    t.string "channel", limit: 50
    t.string "time", limit: 50
    t.integer "num"
    t.string "version", limit: 50
    t.string "regioncode", limit: 25
    t.index ["gameid", "channel", "time", "version", "regioncode"], name: "index_reg"
  end

  create_table "tbl_realtimeretention", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "gamecode", comment: "游戏ID"
    t.string "statdate", limit: 20, comment: "统计日期"
    t.string "channelcode", limit: 20, comment: "道渠代码"
    t.string "activetype", limit: 10, comment: "2:次日留存,3:3日留存以此类推"
    t.string "activenum", limit: 20, comment: "留存账户数"
    t.string "newnum", limit: 20, comment: "新增账户数"
    t.string "country", limit: 20, comment: "国家"
    t.string "time", limit: 20, comment: "数据所在小时（24小时）"
    t.index ["gamecode", "country"], name: "index_online"
    t.index ["statdate", "gamecode"], name: "index_online1"
  end

  create_table "tbl_systemoperationlog", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "type"
    t.integer "optype"
    t.text "entity"
    t.integer "userid"
    t.string "logtime", limit: 19
  end

end
