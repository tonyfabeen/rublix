require 'bundler/setup'
require 'rublix'
Bundler.require(:default)


class ContainerService

  attr_accessor :errors, :container

  def initialize(params)
    @errors = []
    @container = params
    validate
  end

  def create
    return false if @errors.any?
    container = Rublix::LXC::Container.new(@container['name'])
    container.create
    @errors << "Errors on Create Container. Check Logs." unless container.defined?
    container.start
  end


  def response_errors
    error_hash = {:errors => @errors}
    error_hash.to_json
  end

  private

  def validate
    @errors << "Name must be filled" if @container['name'].nil?
  end


end

get '/lxc-config-path' do
  Rublix::LXC.config_path
end

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
    container.response_errors
  end
end

