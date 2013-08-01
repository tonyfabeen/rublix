require 'bundler/setup'
require 'rublix'
Bundler.require(:default)

def json_errors(messages)
  raise "Messages must be an Array" unless messages.is_a?(Array)
  error_hash = {:errors => messages}
  error_hash.to_json
end

get '/lxc-config-path' do
  Rublix::LXC.config_path + "\n"
end

get '/lxc-version' do
  Rublix::LXC.version + "\n"
end

#curl -X POST -H "Content-Type: application/json" -d '{"name":"containerplus"}' http://localhost:6000/containers/create
post '/containers/create' do
  container = JSON.parse(request.body.read)
  if container['name'].nil?
    status 422
    return json_errors(["Name must be filled"])
  end

  status 200
  container_hash = {:name => container['name']}
  container_hash.to_json
end
