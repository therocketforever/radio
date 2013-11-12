class Application < Sinatra::Base
  
  enable :inline_templates, :logging

 # configure(:production) { Bundler.require(:production) }
 # configure(:development) { Bundler.require(:development) }
 # configure(:test) {}

 # get "/style.css" do
 #   content_type :css, :charset => "utf-8"
 #   scss :style
 # end

 # get '/' do
 #   slim :index
 # end

 # get '/pry' do
 #   binding.pry
 # end

 # get '/diag' do
 #   binding.pry
 #   @diag = JSON.parse(open("http://gourami.dev/api/statuses/ping_time").read).mash
 #   binding.pry
 # end


  set :server, 'thin'
  set :sockets, []

  get '/' do
    unless request.websocket?
      erb :index
    else
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
end

#binding.pry

__END__
@@ index
<html>
  <body>
     <h1>Simple Echo & Chat Server</h1>
     <form id="form">
       <input type="text" id="input" value="send a message"></input>
     </form>
     <div id="msgs"></div>
  </body>

  <script type="text/javascript">
    window.onload = function(){
      (function(){
        var show = function(el){
          return function(msg){ el.innerHTML = msg + '<br />' + el.innerHTML; }
        }(document.getElementById('msgs'));

        var ws       = new WebSocket('ws://' + window.location.host + window.location.pathname);
        ws.onopen    = function()  { show('websocket opened'); };
        ws.onclose   = function()  { show('websocket closed'); }
        ws.onmessage = function(m) { show('websocket message: ' +  m.data); };

        var sender = function(f){
          var input     = document.getElementById('input');
          input.onclick = function(){ input.value = "" };
          f.onsubmit    = function(){
            ws.send(input.value);
            input.value = "send a message";
            return false;
          }
        }(document.getElementById('form'));
      })();
    }
  </script>
</html>
