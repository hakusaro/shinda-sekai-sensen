#coding: utf-8

require 'sinatra'

set :sessions => true, :logging => true, :dump_errors => true,
  :environment => :development

set :old_db_settings, {:user => 'shinda',
  :password => 'RRJPfdJV9MADQGL3',
  :host => 'direct.shankshock.com',
  :port => 3306,
  :db => 'playerdata'}

get '/' do
  erb :index
end