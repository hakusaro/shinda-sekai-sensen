#coding: utf-8

require 'sinatra'
require 'sinatra/session'
require 'mysql2'

set :logging => true, :dump_errors => true, :environment => :development

set :db_settings, {:user => 'shinda',
  :password => 'RRJPfdJV9MADQGL3',
  :host => 'direct.shankshock.com',
  :port => 3306}

get '/' do
  erb :index
end

post '/login/pin/' do

end

get '/login/pin/' do
  redirect to('/')
end

get '/login/steam' do
  redirect to('/')
end

class WarningDatabase
  def initialize(user, password, hostname, port)
    @user = user
    @password = password
    @hostname = hostname
    @port = port
  end

  def connect

  end
end