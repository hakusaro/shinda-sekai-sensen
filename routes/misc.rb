get '/' do
  output = ""
  output << @header
  output << partial(:index)
  output << partial(:footer)
  output
end

get '/test/test/?' do
  output = ""
  output << @header
  output << partial(:generic, :locals => { title: 'This is a title', subhead: '', message: 'Lorem ipsum here.', link: '/', link_text: 'Return Home'})
  output << partial(:footer)
  output
end