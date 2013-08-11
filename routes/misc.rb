get '/' do
  output = ""
  output << @header
  output << partial(:index)
  output << partial(:footer)
  output
end

get '/test/?' do
  output = ""
  output << @header
  output << partial(:warning)
  output << partial(:footer)
  output
end