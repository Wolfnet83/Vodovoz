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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 0) do

  create_table "cdr", :id => false, :force => true do |t|
    t.datetime "calldate",                                  :null => false
    t.string   "clid",        :limit => 80, :default => "", :null => false
    t.string   "src",         :limit => 80, :default => "", :null => false
    t.string   "dst",         :limit => 80, :default => "", :null => false
    t.string   "dcontext",    :limit => 80, :default => "", :null => false
    t.string   "channel",     :limit => 80, :default => "", :null => false
    t.string   "dstchannel",  :limit => 80, :default => "", :null => false
    t.string   "lastapp",     :limit => 80, :default => "", :null => false
    t.string   "lastdata",    :limit => 80, :default => "", :null => false
    t.integer  "duration",                  :default => 0,  :null => false
    t.integer  "billsec",                   :default => 0,  :null => false
    t.string   "disposition", :limit => 45, :default => "", :null => false
    t.integer  "amaflags",                  :default => 0,  :null => false
    t.string   "accountcode", :limit => 20, :default => "", :null => false
    t.string   "uniqueid",    :limit => 32, :default => "", :null => false
    t.string   "userfield",                 :default => "", :null => false
  end

  create_table "clients", :force => true do |t|
    t.string "company",      :limit => 70, :null => false
    t.string "phone_number", :limit => 20, :null => false
    t.string "contact",      :limit => 70, :null => false
  end

end
