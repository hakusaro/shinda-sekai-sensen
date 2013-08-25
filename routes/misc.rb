get '/' do
  output = @header
  output << partial(:index)
  output << partial(:footer)
  output
end

get '/test/?' do
  output = ""
  output << @header
  output << partial(:new_warning)
  output << partial(:footer)
  output
end