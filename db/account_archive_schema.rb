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

  create_table "tbl_account", id: :integer, default: nil, charset: "gbk", force: :cascade do |t|
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
    t.index ["name"], name: "name", unique: true
    t.index ["phone"], name: "phone"
  end

  create_table "tbl_accountbinding", id: :integer, default: 0, charset: "gbk", force: :cascade do |t|
    t.integer "gamecode", default: 0, null: false
    t.string "clientid", limit: 100, default: "", null: false
    t.index ["clientid"], name: "account_binding_clientid"
  end

  create_table "tbl_buy_1", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_10", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_11", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_12", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_13", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_14", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_15", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_16", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_17", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_18", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_19", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_2", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_20", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_21", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_22", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_23", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_24", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_25", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_26", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_27", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_3", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_4", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_5", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_6", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_7", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_8", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_buy_9", id: :integer, default: nil, charset: "utf8", force: :cascade do |t|
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

  create_table "tbl_fee_1", id: :integer, default: nil, charset: "latin1", options: "ENGINE=InnoDB DELAY_KEY_WRITE=1", force: :cascade do |t|
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

  create_table "tbl_fee_10", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_11", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_12", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_13", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_14", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_15", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_16", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_17", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_18", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_19", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_2", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_20", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_21", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_22", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_23", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_24", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_25", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_26", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_27", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_28", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_29", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_3", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_30", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_31", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_32", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_4", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_5", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_6", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_7", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_8", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_fee_9", id: :integer, default: nil, charset: "latin1", force: :cascade do |t|
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

  create_table "tbl_imoneycard", id: :integer, default: nil, charset: "gbk", force: :cascade do |t|
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

  create_table "tbl_partition", id: false, charset: "gbk", force: :cascade do |t|
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

end
