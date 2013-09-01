class WarningDatabase
  # Public: Constructor
  #
  # username - The database username to connect to.
  # password - The password used during the auth process.
  # hostname - The host of the MySQL server.
  # port     - The port MySQL is running on.
  # database - The name of the database to connect to.
  #
  # Examples
  #
  #   db = WarningDatabase.new('root', '', 'localhost', 3306, 'shinda')
  #   db.connect
  #   
  # Returns a new WarningDatabase that isn't connected.
  def initialize(username, password, hostname, port, database)
    @username = username
    @password = password
    @hostname = hostname
    @port = port
    @database = database
  end

  # Public: Connects to the MySQL server.
  def connect
    @sql_client = Mysql2::Client.new(:host => @hostname,
    :username => @username,
    :password => @password,
    :port => @port,
    :cast_booleans => true,
    :database => @database,
    :reconnect => true)
  end

  #Public: Disconnects from the MySQL server.
  def disconnect
    @sql_client.close
  end

  # Public: Determines if a warning exists with the given pin number.
  #
  # pin - The pin number.
  #
  # Examples
  #
  #   db.has_warning?(1234)
  #   # => true
  #
  # Returns if a warning exists at that pin code.
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

  # Public: Checks to see if a warning exists at a given unique ID.
  #
  # text  - This checks to see if a warning exists at a given unique ID.
  #
  # Examples
  #
  #   db.warning_exists?(12)
  #   # => true
  #
  # While similar to has_warning, this method is used to check if a unique warning exists that
  # may or may not be acknowledged. This is useful if getting an old warning or determining if
  # an existing one is acknowledged or not.
  # 
  # A warning may not have a pin.
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

  # Public: Gets a warning from the database using a pin code.
  #
  # pin - The warning's associated pin.
  #
  # Examples
  #
  #   db.get_warning(1234)
  #   # => {"id"=>4,
  #   "target"=>"test",
  #   "admin"=>"1",
  #   "message"=>"hello",
  #   "adminnote"=>"test",
  #   "sendtime"=>"1377420541",
  #   "acktime"=>"1377421258",
  #   "ack"=>true,
  #   "pin"=>"1234",
  #   "type"=>"mc"}
  #
  # Returns a hash containing id (database id), target (playername), admin (admin id), adminnote (text),
  # sendtime (unix epoch), acktime (unix epoch), ack (true/false), pin (int), type (mc/steam)
  def get_warning(pin)
    results = @sql_client.query("SELECT * FROM warnings WHERE pin='#{@sql_client.escape(pin)}'")
    results.each do |row|
      return row
    end
  end

  # Public: Acknowledge a warning.
  #
  # id - The warning to acknowledge.
  #
  # Examples
  #
  #   ack_warning?(1)
  #   # => true
  #
  # Returns if the acknowledgement was a success.
  def ack_warning?(id)
    @sql_client.query("UPDATE warnings SET ack=1, pin=null, acktime='#{Time.now.to_i}' WHERE id=#{id}")
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

  def get_admin_details(email)
    results = @sql_client.query("SELECT * FROM admins WHERE email='#{email}'")
    results.each do |row|
      return row
    end
  end

  def get_admin_details_using_steam(steamid)
    results = @sql_client.query("SELECT * FROM admins WHERE steam64='#{steamid}'")
    results.each do |row|
      return row
    end
  end

  def get_admin_for_id(id)
    results = @sql_client.query("SELECT * FROM admins WHERE id='#{id}'")
    results.each do |row|
      return row
    end
  end

  def add_warning_minecraft(target_name, message, admin_note, admin_id)
    pin = Random.rand(9).to_s + Random.rand(9).to_s + Random.rand(9).to_s + Random.rand(9).to_s

    while has_warning?(pin) do
      pin = Random.rand(9).to_s + Random.rand(9).to_s + Random.rand(9).to_s + Random.rand(9).to_s
    end

    @sql_client.query("INSERT INTO warnings (id, target, aid, message, adminnote, sendtime, acktime, ack, pin, type)
VALUES (null, '#{@sql_client.escape(target_name)}', '#{admin_id}', '#{@sql_client.escape(message)}', '#{@sql_client.escape(admin_note)}',
'#{Time.now.to_i}', 0, 0, '#{pin}', 'mc')")
  end

  def add_flag_minecraft(type, mojang, aid, message)
    @sql_client.query("INSERT INTO flags (id, type, mojang, aid, date, message)
VALUES (null, '#{type}', '#{@sql_client.escape(mojang)}', #{aid}, '#{Time.now.to_i}', '#{@sql_client.escape(message)}')")
  end

  def add_log_entry(type, aid, msg)
    @sql_client.query("INSERT INTO logs (id, type, aid, time, message) VALUES (null, #{type}, #{aid}, #{Time.now.to_i}, '#{msg}')")
  end

  def get_logs(limit)
    @sql_client.query("SELECT * FROM logs ORDER BY id DESC LIMIT #{limit}")
  end

  def get_flags(limit)
    @sql_client.query("SELECT * FROM flags ORDER BY id DESC LIMIT #{limit}")
  end

  def get_warnings(limit)
    @sql_client.query("SELECT * FROM warnings ORDER BY id DESC LIMIT #{limit}")
  end

  def get_admins
    @sql_client.query("SELECT * FROM admins")
  end

  def get_warnings_for_target(user)
    @sql_client.query("SELECT * FROM warnings WHERE target='#{user}'")
  end

  def get_flags_for_target(user)
    @sql_client.query("SELECT * FROM flags WHERE mojang='#{user}' OR steam64='#{user}'")
  end

end