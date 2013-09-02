get '/warning/view/?' do
  if (session?) then
    if (session[:type] == :warning) then
      warning_info = @db.get_warning(session[:pin])
      session[:warning_info] = warning_info
      today = Time.now.strftime('%D')
      send_time = Time.at(warning_info['sendtime'].to_i).strftime('%D')
      admin = @db.get_admin_for_id(warning_info['aid'])
      admin_name = admin['displayname']
      output = @header
      output << partial(:warning, :locals => {
        admin_name: admin_name,
        send_time: send_time,
        access_time: today,
        player_name: warning_info['target'],
        message: markdown(warning_info['message'])
        })
      output << partial(:footer)
      output
    else
      output = @header
      output << partial(:generic, :locals => { title: 'You shouldn\'t be here!',
        subhead: 'You\'ve stumbled upon the twilight zone.',
        message: 'Your account currently has a session that, while valid, is not a session capable of processing this endpoint.',
        link: '/',
        link_text: 'Return Home'})
      output << partial(:footer)
      output
    end
  else
    redirect to('/')
  end
end

get '/warning/ack/?' do
  if (session?) then
    if (session[:type] == :warning) then
      if (@db.ack_warning?(session[:warning_info]['id'])) then
        session_end!(true)
        output = @header
        output << partial(:generic, :locals => { title: 'Warning Acknowledged',
          subhead: 'That\'s all you need to do, for now.',
          message: 'You have acknowledged this warning. Any account restrictions associated (such as being unable to join) no longer exist.',
          link: '/',
          link_text: 'Return Home'})
        output << partial(:footer)
        output
      else
        output = @header
        output << partial(:generic, :locals => { title: 'Something unexpected happened!',
          subhead: 'Unable to acknowledge warning.',
          message: 'We were unable to acknowledge that you read this warning. Nothing has happened - please email shank@shanked.me if this happens.',
          link: '/',
          link_text: 'Return Home'})
        output << partial(:footer)
        output
      end
    else
      redirect to('/')
    end
  else
    redirect to('/')
  end
end