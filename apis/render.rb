require 'tilt/erb' 
require 'actn/api/ui'

class Render < Actn::Api::UI
  STATICS = ['favicon.ico', 'robots.txt', 'humans.txt']
  use Rack::Static, :root => "#{Actn::Api.root}/public", :urls => STATICS  
    
  settings[:public_folder]  = "#{Actn::Api.root}/public"
  settings[:views_folder]   = "#{Actn::Api.root}/views"        
  INDEX = "index.html"
  
  get "/*" do
    filename = env['REQUEST_PATH'][1..-1]
    if filename == ""
      filename = INDEX       
    elsif STATICS.include? filename
      "#{Actn::Api.root}/public/#{filename}"
    else  
      filename = "#{filename}.html" unless filename.include?(".")
    end
    erb filename
  end
  
end