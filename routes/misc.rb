get '/' do
  output = @header
  output << partial(:index)
  output << partial(:footer)
  output
end

get '/test/?' do
  output = ""
  output << @header
  output << partial(:flag_add)
  output << partial(:footer)
  output
end