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

  create_table "tbl_account", id: :integer, charset: "gbk", options: "ENGINE=InnoDB DELAY_KEY_WRITE=1", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "password", default: "", null: false
    t.string "guardpass", limit: 20
    t.bigint "abalance", null: false
    t.datetime "createtime", null: false
    t.string "gamecode", limit: 20, default: "", null: false
    t.datetime "lastlogintime"
    t.integer "status", default: 0, null: false
    t.string "phone", limit: 20
    t.string "recommend"
    t.text "comment"
    t.string "serviceversion", limit: 200, default: "", null: false
    t.integer "bbalance", default: 0, null: false
    t.datetime "lastpaytime"
    t.integer "monthfee", default: 0, null: false
    t.integer "lastmonthfee", default: 0, null: false
    t.integer "modifypasswordtimes", default: 0, null: false
    t.string "model", limit: 200
    t.string "versionpatch"
    t.integer "cbalance", default: 0, null: false
    t.integer "regtype", default: 0, null: false
    t.string "activephone", limit: 20
    t.string "regphone", limit: 20
    t.index ["createtime"], name: "account_createtime_index"
    t.index ["lastlogintime"], name: "account_logintime_index"
    t.index ["name"], name: "name", unique: true
    t.index ["phone"], name: "phone"
  end

  create_table "tbl_account_phone", id: :integer, charset: "utf8", force: :cascade do |t|
    t.string "phoneid", limit: 50, null: false
    t.string "accountname", limit: 50, null: false
  end

  create_table "tbl_accountbinding", id: :integer, default: 0, charset: "gbk", options: "ENGINE=InnoDB DELAY_KEY_WRITE=1", force: :cascade do |t|
    t.integer "gamecode", default: 0, null: false
    t.string "clientid", limit: 100, default: "", null: false
    t.index ["clientid"], name: "account_binding_clientid"
  end

  create_table "tbl_accountcredit", id: :integer, default: 0, charset: "gbk", options: "ENGINE=InnoDB DELAY_KEY_WRITE=1", force: :cascade do |t|
    t.integer "credit", default: 0, null: false
    t.datetime "logouttime"
    t.integer "dayonline", default: 0, null: false
    t.integer "daycredit", default: 0, null: false
  end

  create_table "tbl_agent", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "game"
    t.integer "region"
    t.datetime "planregtime"
    t.integer "regstatus"
    t.datetime "regtime"
    t.integer "accountid"
    t.string "accountname", limit: 40
    t.string "password", limit: 40
    t.string "rolename", limit: 40
    t.datetime "planchargetime"
    t.integer "chargestatus"
    t.datetime "chargetime"
    t.integer "chargeamount"
    t.datetime "planconsumetime"
    t.integer "consumestatus"
    t.datetime "consumetime"
  end

  create_table "tbl_backup_fee", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
    t.integer "charged", limit: 1, default: 0, null: false
    t.datetime "createtime", null: false
    t.datetime "finishtime"
    t.integer "accountid", default: 0, null: false
    t.integer "amount"
    t.string "channel", limit: 20
    t.string "partition", limit: 40, default: "", null: false
    t.integer "money", default: 0, null: false
    t.string "currency", limit: 20
    t.index ["accountid"], name: "accountid"
    t.index ["channel"], name: "channel"
    t.index ["finishtime"], name: "finishtime"
  end

  create_table "tbl_buy", id: :integer, charset: "utf8", force: :cascade do |t|
    t.integer "accountid", default: 0, null: false
    t.datetime "buytime", null: false
    t.string "partition", limit: 40, default: "", null: false
    t.integer "price", default: 0, null: false
    t.integer "playerid", default: 0, null: false
    t.string "playername", limit: 100, default: "", null: false
    t.integer "playerlevel", default: 0, null: false
    t.integer "itemid", default: 0, null: false
    t.string "itemname", limit: 100, default: "", null: false
    t.string "extrainfo", default: "", null: false
    t.integer "itemcount", default: 1, null: false
    t.decimal "money", precision: 11, scale: 4, default: "0.0", null: false
    t.text "detail"
    t.index ["accountid"], name: "accountid"
    t.index ["buytime"], name: "buytime"
    t.index ["partition"], name: "partition"
  end

  create_table "tbl_ccard", primary_key: "cardno", id: { type: :string, limit: 40 }, charset: "gbk", force: :cascade do |t|
    t.string "cardpass", limit: 40
    t.integer "amount"
    t.integer "status"
  end

  create_table "tbl_fee", id: :integer, charset: "latin1", options: "ENGINE=InnoDB DELAY_KEY_WRITE=1", force: :cascade do |t|
    t.integer "charged", limit: 1, default: 0, null: false
    t.datetime "createtime", null: false
    t.datetime "finishtime"
    t.integer "accountid", default: 0, null: false
    t.integer "amount"
    t.string "channel", limit: 100
    t.string "partition", limit: 40, default: "", null: false
    t.integer "money", default: 0, null: false
    t.string "currency", limit: 10, default: "", null: false
    t.index ["accountid"], name: "accountid"
    t.index ["channel"], name: "channel"
    t.index ["finishtime"], name: "finishtime"
  end

  create_table "tbl_fee_mh", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
    t.integer "charged", limit: 1, default: 0, null: false
    t.datetime "createtime", null: false
    t.datetime "finishtime"
    t.integer "accountid", default: 0, null: false
    t.integer "amount"
    t.string "channel", limit: 20
    t.string "partition", limit: 40, default: "", null: false
    t.integer "money", default: 0, null: false
    t.string "currency", limit: 10, default: "", null: false
    t.index ["accountid"], name: "accountid"
    t.index ["channel"], name: "channel"
    t.index ["finishtime"], name: "finishtime"
  end

  create_table "tbl_id", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "usedid", default: 0, null: false
  end

  create_table "tbl_imoneycard", id: :integer, charset: "gbk", options: "ENGINE=InnoDB DELAY_KEY_WRITE=1", force: :cascade do |t|
    t.string "cardno", limit: 20, null: false
    t.string "password", limit: 20, null: false
    t.string "gamecode", limit: 20, null: false
    t.integer "amount", null: false
    t.datetime "createtime", null: false
    t.integer "accountid", null: false
    t.integer "used", null: false
    t.datetime "usetime"
    t.integer "useaccount", default: -1, null: false
    t.string "usegamecode", limit: 20
    t.index ["accountid"], name: "imoneycard_accountid_index"
    t.index ["cardno"], name: "cardno"
    t.index ["createtime"], name: "imoneycard_createtime_index"
    t.index ["useaccount"], name: "imoneycard_useaccount_index"
  end

  create_table "tbl_logininfo", id: :integer, charset: "gbk", options: "ENGINE=InnoDB DELAY_KEY_WRITE=1", force: :cascade do |t|
    t.integer "accountid", default: 0, null: false
    t.datetime "logintime", null: false
    t.string "serviceid", limit: 200, default: "", null: false
    t.string "sessionid", limit: 200, default: "", null: false
    t.integer "valid", limit: 1, default: 0, null: false
    t.string "partition", limit: 40, default: "", null: false
    t.index ["accountid"], name: "accountid"
    t.index ["logintime"], name: "index_logininfo_logintime"
  end

  create_table "tbl_partition", id: false, charset: "gbk", options: "ENGINE=InnoDB DELAY_KEY_WRITE=1", force: :cascade do |t|
    t.integer "id", null: false
    t.string "partition", limit: 40, default: "", null: false
    t.bigint "abalance", default: 0, null: false
    t.bigint "bbalance", default: 0, null: false
    t.datetime "lastpaytime"
    t.datetime "createtime"
    t.text "detail"
    t.index ["id"], name: "id"
    t.index ["partition"], name: "partition"
  end

  create_table "tbl_purchased", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "accountid", default: 0, null: false
    t.integer "code", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "createtime", null: false
    t.integer "feeid", default: 0, null: false
    t.string "phone", limit: 200
    t.index ["accountid"], name: "accountid"
    t.index ["phone"], name: "phone"
  end

  create_table "tbl_recommendrequest", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "account", default: 0, null: false
    t.datetime "rectime", null: false
    t.string "gamecode", limit: 40, default: "", null: false
    t.string "targetphone", limit: 20, default: "", null: false
    t.datetime "validtime", null: false
    t.index ["account"], name: "account"
    t.index ["targetphone"], name: "targetphone"
  end

  create_table "tbl_recommendreward", id: :integer, charset: "gbk", force: :cascade do |t|
    t.datetime "rewardtime", null: false
    t.integer "guestid", default: 0, null: false
    t.string "guestphone", limit: 20
    t.string "guestgamecode", limit: 40
    t.integer "roleid", default: 0, null: false
    t.integer "guestlevel", default: 0, null: false
    t.integer "guestrewardvalue", default: 0, null: false
    t.integer "ownerid", default: 0, null: false
    t.integer "ownerrewardvalue", default: 0, null: false
    t.integer "rewardcode", default: 0, null: false
    t.index ["guestid"], name: "guestid"
    t.index ["guestphone"], name: "guestphone"
  end

  create_table "tbl_sequence", id: :integer, charset: "gbk", force: :cascade do |t|
    t.integer "usedid", default: 0, null: false
  end

  create_table "tbl_sequence2", id: :integer, charset: "gbk", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "usedid", default: 0, null: false
    t.integer "maxid", default: 0, null: false
    t.integer "step", default: 0, null: false
    t.index ["name"], name: "name", unique: true
  end

end
