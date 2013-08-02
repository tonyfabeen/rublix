require File.expand_path('./api/app')
Bundler.require(:test)
require 'test/unit'
require 'mocha/setup'

class ApiTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_lxc_config_path
    get '/lxc-config-path'
    assert_equal '/var/lib/lxc', last_response.body
  end

  def test_lxc_version
    get '/lxc-version'
    assert_equal '0.9.0', last_response.body
  end


  def test_containers_create
    Rublix::LXC::Container.any_instance.stubs(:create).returns(true)
    Rublix::LXC::Container.any_instance.stubs(:defined?).returns(true)
    Rublix::LXC::Container.any_instance.stubs(:start).returns(true)

    container_name = "test#{rand(10)}"
    json = {:name => container_name}.to_json
    post '/containers/create', json, {'Content-Type' => 'application/json'}
    assert_equal '{"name":"'+container_name+'"}', last_response.body

  end

end
