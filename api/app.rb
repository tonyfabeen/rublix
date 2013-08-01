require 'bundler/setup'
require 'rublix'
Bundler.require(:default)

get '/lxc-config-path' do
  Rublix::LXC.config_path + "\n"
end

get '/lxc-version' do
  Rublix::LXC.version + "\n"
end

#curl -X POST -H "Content-Type: application/json" -d '{"name":"containerplus"}' http://localhost:6000/containers/create
post '/containers/create' do
  container = JSON.parse(request.body.read)
  container_hash = {:name => container['name']}
  container_hash.to_json
end
