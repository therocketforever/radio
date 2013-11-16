class API < Grape::API
  version 'api', using: :path, vendor: 'api-provider'
  format :json

  resource :development do
    desc "Return the time for testing."
    get :ping_time do
      { :time => Time.now }
    end
  end

puts "API:         ".color(:blue) + "Online".color(:green)
end