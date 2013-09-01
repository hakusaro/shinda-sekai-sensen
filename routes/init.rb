before '/*' do
  @db = WarningDatabase.new(settings.db_settings[:user],
  settings.db_settings[:password],
  settings.db_settings[:host],
  settings.db_settings[:port],
  settings.db_settings[:database])
  @db.connect
  if (session? && session[:type] == :admin) then
    @header = partial(:top, :locals => { login_state: true, account: session[:user]})
  else 
    @header = partial(:top, :locals => { login_state: false})
  end
end

before '/backstage*' do
  if (!session? || session[:type] != :admin) then
    redirect to('/')
  end
end

after '/*' do
  @db.disconnect
end

require_relative 'logins'
require_relative 'warnings'
require_relative 'misc'
require_relative 'backstage'