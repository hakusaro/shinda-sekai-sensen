#coding: utf-8

require 'sinatra'
require 'sinatra/session'
require 'mysql2'
require 'formatador'
require 'sinatra/partial'
require 'omniauth-gplus'
require 'omniauth'
require 'omniauth-openid'
require 'rdiscount'
require 'pry'
require 'omniauth-openid'
require 'openid/store/filesystem'
require 'awesome_print'
require 'yaml'

require_relative 'helpers/constants'
require_relative 'helpers/database'
require_relative 'models/admin_user'
require_relative 'models/warning_user'

temp_config = ""

File.open('config.yaml', 'r').each_line do |line|
  temp_config << line
end

app_config = YAML.load(temp_config)

if (ENV['environment'] ? ENV['environment'].to_sym : :dev == :production) then
  app_config['db_user'] = ENV['db_user']
  app_config['db_pass'] = ENV['db_pass']
  app_config['db_host'] = ENV['db_host']
  app_config['db_port'] = ENV['db_port']
  app_config['db_name'] = ENV['db_name']
  app_config['google_user_token'] = ENV['google_user_token']
  app_config['google_token_secret'] = ENV['google_token_secret']
  app_config['session_secret'] = ENV['session_secret']
  set :environment => :production
else
  set :environment => :dev
  set :bind => '0.0.0.0'
  set :port => 4567
end

set :logging => true,
  :dump_errors => true,
  :raise_errors => true,
  :session_secret => app_config['session_secret'],
  :partial_template_engine => :erb

if settings.environment == :production then
  # set :logging => false,
  #   :dump_errors => false,
  #   :raise_errors => false
end

set :db_settings,
{:user => app_config['db_user'],
:password => app_config['db_pass'],
:host => app_config['db_host'],
:port => app_config['db_port'],
:database => app_config['db_name']}


use OmniAuth::Builder do
  provider :gplus, app_config['google_user_token'], app_config['google_token_secret']
  # provider :open_id, :name => 'steam', 'identifier' => 'http://steamcommunity.com/openid'
end

require_relative 'routes/init'