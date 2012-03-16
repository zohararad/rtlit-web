class RTLitWeb < Sinatra::Base

  Rack::Mime::MIME_TYPES.merge!(".less"=>"application/octet-stream", ".css" =>"application/octet-stream", ".scss" =>"application/octet-stream")

  set :haml, :format => :html5

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
    response.headers['content_type'] = "application/octet-stream"
    attachment('rtl-%s' % name)
    response.write(rtl_css)
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end