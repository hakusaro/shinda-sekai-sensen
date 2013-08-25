get '/' do
  output = @header
  output << partial(:index)
  output << partial(:footer)
  output
end

not_found do
  output = @header
  output << partial(:not_found)
  output << partial(:footer)
  output
end

error do
  output = @header
  output << partial(:error)
  output << partial(:footer)
  output
end

# get '/test/?' do
#   output = ""
#   output << @header
#   output << partial(:not_found)
#   output << partial(:footer)
#   output
# end