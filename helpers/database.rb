class WarningDatabase
  def initialize(username, password, hostname, port, database)
    @username = username
    @password = password
    @hostname = hostname
    @port = port
    @database = database
  end

  def connect
    @sql_client = Mysql2::Client.new(:host => @hostname,
    :username => @username,
    :password => @password,
    :port => @port,
    :cast_booleans => true,
    :database => @database,
    :reconnect => true)
  end

  def disconnect
    @sql_client.close
  end

  def has_warning?(pin)
    results = @sql_client.query("SELECT * FROM warnings WHERE pin='#{@sql_client.escape(pin)}'")
    # Formatador.display_table(results)
    if results.count > 0 then
      results.each do |row|
        if (row['ack'] == false) then
          return true
        end
      end
      return false
    else
      return false
    end
  end

  def warning_exists?(id)
    results = @sql_client.query("SELECT * FROM warnings WHERE id=#{id}")
    if results.count > 0 then
      results.each do |row|
        if (!row[:ack]) then
          return false
        else
          return true
        end
      end
    else
      return false
    end
  end

  def get_warning(pin)
    results = @sql_client.query("SELECT * FROM warnings WHERE pin='#{@sql_client.escape(pin)}'")
    results.each do |row|
      return row
    end
  end

  def ack_warning?(id)
    @sql_client.query("UPDATE warnings SET ack=1, pin=null WHERE id=#{id}")
    if warning_exists?(id) then
      return false
    else
      return true
    end
  end

  def is_admin?(email)
    results = @sql_client.query("SELECT * FROM admins WHERE email='#{email}'")
    if results.count > 0 then
      return true
    else
      return false
    end
  end
end