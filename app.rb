require 'rubygems'
require 'bundler'

Bundler.require

class RTLitWeb < Sinatra::Base

  Rack::Mime::MIME_TYPES.merge!(".less"=>"text/css", ".scss" =>"text/css")

  set :haml, :format => :html5
  set :static, true
  set :public_folder, 'public'

  get '/' do
    haml :index
  end

  post '/convert' do
    unless params[:uploaded_file] &&
           (tmpfile = params[:uploaded_file][:tempfile]) &&
           (name = params[:uploaded_file][:filename])

      @error = "No file selected"
      return haml(:index)
    end

    STDERR.puts "Uploading file, original name #{name.inspect}"
    rtl_css = RTLit::Converter.to_rtl tmpfile.read
    response.headers['content_type'] = "text/css"
    attachment('rtl-%s' % name)
    response.write(rtl_css)
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end