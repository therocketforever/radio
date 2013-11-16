class Application < Sinatra::Base
  
  enable :inline_templates, :logging

  configure(:production)  { Bundler.require(:production) }
  configure(:development) { Bundler.require(:development) }
  configure(:test)        { Bundler.require(:test) }

 # get "/style.css" do
 #   content_type :css, :charset => "utf-8"
 #   scss :style
 # end

  get '/pry' do
    binding.pry
  end

  set :server, 'thin'
  set :sockets, []

  get '/' do
    unless request.websocket?
      puts "Request is NOT a WebSocket".color(:yellow)
      slim :index
    else
      puts "Request IS a WebSocket".color(:green)
      request.websocket do |ws|
        ws.onopen do
          ws.send("Hello World!")
          settings.sockets << ws
        end
        ws.onmessage do |msg|
          EM.next_tick { settings.sockets.each{|s| s.send(msg) } }
        end
        ws.onclose do
          warn("wetbsocket closed")
          settings.sockets.delete(ws)
        end
      end
    end
  end

  get '/radio' do
    slim :radio
  end

puts "Application: ".color(:blue) + "Online".color(:green)
end

#binding.pry