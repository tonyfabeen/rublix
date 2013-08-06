require 'rubygems'
require 'bundler/setup'
require 'rublix'
require File.expand_path('./api/container_service')
Bundler.require(:default)

#
get '/lxc-config-path' do
  Rublix::LXC.config_path
end

#
get '/lxc-version' do
  Rublix::LXC.version
end

#curl -X POST -H "Content-Type: application/json" -d '{"name":"containerplus"}' http://localhost:6000/containers/create
post '/containers/create' do

  container_params = JSON.parse(request.body.read)
  container_service = ContainerService.new(container_params)

  if container_service.create
    status 200
    container_hash = {:name => container_params['name']}
    container_hash.to_json
  else
    status 422
    container_service.response_errors
  end

end

#curl -X POST http://localhost:6000/containers/containerplus/start
post '/containers/:name/start' do

  container_service = ContainerService.new(params)

  if container_service.start
    status 204
  else
    status 422
    container_service.response_errors
  end

end

post '/containers/:name/stop' do

  container_service = ContainerService.new(params)

  if container_service.stop
    status 204
  else
    status 422
    container_service.response_errors
  end

end

post '/containers/:name/destroy' do

  container_service = ContainerService.new(params)

  if container_service.destroy
    status 204
  else
    status 422
    container_service.response_errors
  end

end

post '/containers/:name/reboot' do

  container_service = ContainerService.new(params)

  if container_service.reboot
    status 204
  else
    status 422
    container_service.response_errors
  end

end

post '/containers/:name/shutdown' do

  container_service = ContainerService.new(params)

  if container_service.shutdown
    status 204
  else
    status 422
    container_service.response_errors
  end

end

