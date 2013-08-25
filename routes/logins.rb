post '/login/pin/?' do
  if (params[:pin]) then
    if (@db.has_warning?(params[:pin])) then
      if session? then
        session_end!(true)
      end
      session_start!
      session[:type] = :warning
      session[:pin] = params[:pin]
      redirect to('/warning/view')
    else
      output = @header
      output << partial(:generic, :locals => { title: 'Lookup Failed.',
        subhead: '',
        message: 'Unfortunately, the code you entered either went to something that was expired, or you typed an invalid one.
                  Either way, it would be advisable to go back and verify that you were indeed given a code, and make sure to type it correctly.
                  If you didn\'t get a code, you don\'t need to be here!',
        link: '/',
        link_text: 'Return Home'})
      output << partial(:footer)
      output
    end
  end
end

get '/login/pin/?' do
  redirect to('/')
end

get '/auth/gplus/callback/?' do
  authentication_hash = request.env['omniauth.auth']
  if @db.is_admin?(authentication_hash[:info][:email]) then
    session_start!
    session[:type] = :admin
    session[:user] = authentication_hash[:info][:email]
    admin_info = @db.get_admin_details(authentication_hash[:info][:email])
    session[:display_name] = admin_info['displayname']
    session[:mojang] = admin_info['mojang']
    session[:steam64] = admin_info['steam64']
    session[:permissions] = admin_info['permissions']
    session[:user_id] = admin_info['id']
    @db.add_log_entry($log_type[:web_login], session[:user_id], "#{session[:display_name]} logged into Shinda Sekai Sensen.")
    redirect to('/')
  else
    session_end!(true)
    output = @header
    output << partial(:generic, :locals => {
      title: 'Login failed.',
      subhead: 'You aren\'t an admin!',
      message: "The login attempt failed, because you do not have access to this area of Shinda Sekai Sensen.
                If this is unexpected, and you should have access, please notify Shank immediately.<br /><br />
                The account you tried to login with was: #{authentication_hash[:info][:email]}.",
      link: '/',
      link_text: 'Return Home'})
    output << partial(:footer)
  end
end

get '/auth/failure/?' do
  session_end!(true)
  output = @header
  output << partial(:generic, :locals => {
    title: 'Authentication Failure',
    subhead: 'OmniAuth does not know what to do.',
    message: 'During the authentication phase with Google+, something unexpected happened that caused OmniAuth to put you here.
              This error happens infrequently, usually when an incorrect call was made to /auth/gplus/ without a callback.
              <br /><br />
              To solve this problem, we have deleted your session. Please attempt to login again.',
    link: '/auth/gplus/',
    link_text: 'Login Again'})
  output << partial(:footer)
  output
end

get '/login/unauthorized/?' do
  session_end!(true)
  output = @header
  output << partial(:generic, :locals => {
    title: 'Unauthorized',
    subhead: '',
    message: 'Attempting to access that page resulted in failing authorization checks. Sorry about that.',
    link: '/',
    link_text: 'Return Home'
    })
  output << partial(:footer)
  output
end

get '/logout/?' do
  @db.add_log_entry($log_type[:web_logout], session[:user_id], "#{session[:display_name]} logged out of Shinda Sekai Sensen.")
  session_end!(true)
  redirect to('/')
end