require 'tilt/erb' 
require 'actn/api/ui'

class Render < Actn::Api::UI
  
  use Rack::Static, :root => "#{Actn::Api.root}/public", :urls => ['favicon.ico']  
    
  settings[:public_folder]  = "#{Actn::Api.root}/public"
  settings[:views_folder]   = "#{Actn::Api.root}/views"        
  INDEX = "index.html"
  
  get "/*" do
    filename = env['REQUEST_PATH'][1..-1]
    filename = "#{filename}.html" unless filename.include?(".")
    filename = INDEX if filename == ""
    erb filename
  end
  
end