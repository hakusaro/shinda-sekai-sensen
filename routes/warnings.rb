get '/warning/view/?' do
  if (session?) then
    if (session[:type] == :warning) then
      warning_info = db.get_warning(session[:pin])
      session[:warning_info] = warning_info
      return "Warning information: ID: #{warning_info['id']}, 
      UserID: #{warning_info['userid']}, 
      EntryDate: #{warning_info['entrydate']}, 
      Message: #{warning_info['message']}, 
      Ack: #{warning_info['ack']}"
    else
      output = ""
      output << @header
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
      if (db.ack_warning?(session[:warning_info]['id'])) then
        session_end!(true)
        output = ""
        output << @header
        output << partial(:generic, :locals => { title: 'Warning Acknowledged',
          subhead: 'That\'s all you need to do, for now.',
          message: 'You have acknowledged this warning. Any account restrictions associated (such as being unable to join) no longer exist.',
          link: '/',
          link_text: 'Return Home'})
        output << partial(:footer)
        output
      else
        output = ""
        output << @header
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