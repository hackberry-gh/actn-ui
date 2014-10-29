require 'erb'
require 'tilt/erb' 
require 'actn/api/ui'

class Render < Actn::Api::UI
  STATICS = ['favicon.ico', 'robots.txt', 'humans.txt']
  use Rack::Static, :root => "#{Actn::Api.root}/public", :urls => STATICS  
    
  settings[:public_folder]  = "#{Actn::Api.root}/public"
  settings[:views_folder]   = "#{Actn::Api.root}/views"        
  
  helpers do
    
    def locale
      env['locale'] ||= I18n.locale.to_s
    end
    
    def set_locale locale
      # if I18n.available_locales.include?(locale.to_sym)
        I18n.locale = locale.to_sym
      # end
    end
  
    def route path
      filename = path[1..-1] # remove first /
      if filename == ""
        filename = "index.html"       
      elsif STATICS.include? filename
        File.read "#{Actn::Api.root}/public/#{filename}"
      else  
        filename = "#{filename}.html" unless filename.include?(".")
      end
      puts "FILENAME #{filename}"
      begin
        extname = File.extname(filename)[1..-1].to_sym
        content_type extname
        erb filename
      rescue Errno::ENOENT => e
        status 404
      end
    end
  end
  
  get "/:locale/*", :locale => /^([a-z]{2}|[a-z]{2}\-[A-Z]{2})\// do
    set_locale params[:locale].gsub(/\/$/,'')
    path = env['REQUEST_PATH'].gsub(/\/#{params[:locale]}/,'/')
    puts "PATH #{path.inspect}"
    route path
  end
  
  get "/:locale", :locale => /^([a-z]{2}|[a-z]{2}\-[A-Z]{2})$/ do
    set_locale params[:locale]
    route "/"
  end
  
  get "/*" do
    route env['REQUEST_PATH']
  end
  
  
  
end