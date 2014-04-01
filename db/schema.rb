# encoding: UTF-8
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

<<<<<<< HEAD
ActiveRecord::Schema.define(version: 20140401051535) do
=======
ActiveRecord::Schema.define(version: 20140321030937) do
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb

  create_table "accounts", force: true do |t|
    t.string   "email"
    t.string   "password"
    t.string   "username"
    t.string   "guid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "organization"
    t.string   "space"
    t.string   "codenum"
    t.string   "hascode"
  end

  create_table "appcodes", force: true do |t|
    t.string   "appguid"
    t.string   "zipname"
    t.string   "size"
    t.string   "userguid"
    t.string   "username"
    t.string   "appname"
    t.string   "version"
    t.boolean  "active"
    t.datetime "uploaddate"
    t.string   "appdetect"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "apps", force: true do |t|
    t.string   "userguid"
    t.string   "username"
    t.string   "appguid"
    t.string   "zipfilename"
    t.string   "version"
    t.string   "appname"
    t.string   "appframework"
    t.boolean  "active"
    t.datetime "uploaddate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "org"
    t.string   "space"
    t.string   "hascode"
    t.datetime "startime"
  end

  create_table "appstartpros", force: true do |t|
    t.string   "username"
    t.string   "appid"
    t.string   "token"
    t.string   "log"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "orglocals", force: true do |t|
    t.string   "name"
    t.string   "guid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

<<<<<<< HEAD
  create_table "rundata_machinecpus", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rundata_machinedisks", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rundata_machinemems", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

=======
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
  create_table "serviceinsts", force: true do |t|
    t.string   "userguid"
    t.string   "username"
    t.string   "serviceguid"
    t.string   "name"
    t.string   "version"
    t.string   "sertype"
    t.string   "provider"
    t.string   "plan"
    t.string   "org"
    t.string   "space"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "approvetime"
  end

  create_table "servicelists", force: true do |t|
    t.string   "userguid"
    t.string   "username"
    t.string   "name"
    t.string   "type"
    t.string   "plan"
    t.datetime "apply_at"
    t.datetime "approve_at"
    t.datetime "reject_at"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "isrej"
    t.string   "isdelete"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", unique: true
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

<<<<<<< HEAD
  create_table "userlogs", force: true do |t|
    t.string   "username"
    t.string   "log"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

=======
>>>>>>> e582676e82b04eeed2cf6322a8b13e3b25c94fbb
end
