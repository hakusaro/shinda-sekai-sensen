get '/backstage/?' do
  @db.add_log_entry($log_type[:view_backstage], session[:admin_user].admin_id, "#{session[:admin_user].display_name} viewed the backstage index.")
  output = @header
  output << partial(:backstage)
  output << partial(:footer)
  output
end

get '/backstage/warn/?' do
  @db.add_log_entry($log_type[:view_new_warning], session[:admin_user].admin_id, "#{session[:admin_user].display_name} viewed the warning creation page.")
  output = @header
  output << partial(:new_warning)
  output << partial(:footer)
  output
end

get '/backstage/warn/saved/?' do
  @db.add_log_entry($log_type[:view_new_warning], session[:admin_user].admin_id, "#{session[:admin_user].display_name} viewed the warning creation post error page.")
  output = @header
  output << partial(:new_warning_post, :locals => {
    target_username: session[:warning_target][:name],
    message: session[:warning_target][:message],
    note: session[:warning_target][:admin_note]
    })
  output << partial(:footer)
  output
end

get '/backstage/warn/preview/?' do
  output = @header
  output << partial(:generic, :locals => {
    title: 'Error!',
    subhead: '',
    message: 'Must POST to /backstage/warn/preview.',
    link: '/backstage/warn/',
    link_text: 'Return to Warning Creation'
    })
  output << partial(:footer)
  output
end

post '/backstage/warn/preview/?' do
  target = {name: params[:username], message: params[:message], admin_note: params[:admin_note]}
  session[:warning_target] = target

  puts "Target hash: " + target.inspect

  if (!target[:name] || !target[:message] || !target[:admin_note]) then
    redirect to('/backstage/warn/saved/')
  end

  if (target[:name].length < 3 || target[:message].length < 100) then
    redirect to('/backstage/warn/saved')
  end

  output = @header
  output << partial(:warning_preview, :locals => {
    admin_name: session[:admin_user].display_name,
    send_time: Time.now.strftime('%D'),
    player_name: target[:name],
    message: markdown(target[:message])
    })
  output << partial(:footer)
  output
end

get '/backstage/warn/apply/?' do 
  target = session[:warning_target]

  if (!target[:name] || !target[:message] || !target[:admin_note]) then
    redirect to('/backstage/warn/saved/')
  end

  @db.add_log_entry($log_type[:send_warning], session[:admin_user].admin_id, "#{session[:admin_user].display_name} sent a warning to #{target[:name]}.")
  @db.add_warning_minecraft(target[:name], target[:message], target[:admin_note], session[:admin_user].admin_id)

  session[:warning_target] = nil

  output = @header
  output << partial(:generic, :locals => {
    title: 'Warning Added',
    subhead: 'A warning has been added.',
    message: 'A warning has been created. That user cannot log into either Minecraft or Steam games until
    that warning is cleared. Thanks for using Shinda Sekai Sensen.',
    link: '/backstage/',
    link_text: 'Return To Backstage'
    })
  output << partial(:footer)
  output
end

get '/backstage/flag/?' do
  @db.add_log_entry($log_type[:view_new_flag], session[:admin_user].admin_id, "#{session[:admin_user].display_name} viewed the flag creation page.")
  output = @header
  output << partial(:flag_add)
  output << partial(:footer)
  output
end

post '/backstage/flag/apply/?' do
  target = {name: params[:username], message: params[:admin_note]}
  session[:flag_target] = target
  if (target[:name].length < 3 || target[:message].length < 10) then
    redirect to('/backstage/flag/saved/?')
  end

  @db.add_log_entry($log_type[:flag_user], session[:admin_user].admin_id, "#{session[:admin_user].display_name} flagged #{target[:name]} as malicious.")
  @db.add_flag_minecraft('direct', target[:name], session[:admin_user].admin_id, target[:message])

  session[:flag_target] = nil

  output = @header
  output << partial(:generic, :locals => {
    title: 'Flag Added',
    subhead: '',
    message: 'The flag was added to the database.',
    link: '/backstage/',
    link_text: 'Return To Backstage'
    })
  output << partial(:footer)
  output
end

get '/backstage/flag/saved/?' do
  @db.add_log_entry($log_type[:view_new_flag], session[:admin_user].admin_id, "#{session[:admin_user].display_name} viewed the flag creation post error page.")
  output = @header
  output << partial(:flag_add_post, :locals => {
    name: session[:flag_target][:name],
    message: session[:flag_target][:message]
    })
  output << partial(:footer)
  output
end

get '/backstage/logs/?' do
  log_dump = @db.get_logs(50000)
  output = ""
  output << @header
  output << partial(:logs, :locals => {log_dump: log_dump})
  output << partial(:footer)
  output
end

get '/backstage/warnings/?' do
  log_dump = @db.get_warnings(50000)
  admins = @db.get_admins
  log_dump.each do |row|
    admins.each do |admin|
      if admin['id'] == row['admin'] then
        row['admin_name'] = admin['displayname']
      end
    end
  end
  output = ""
  output << @header
  output << partial(:warnings, :locals => {log_dump: log_dump})
  output << partial(:footer)
  output
end

get '/backstage/pry/?' do
  binding.pry
end