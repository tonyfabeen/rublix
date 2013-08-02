require File.expand_path('./api/app')
Bundler.require(:test)
require 'test/unit'
require 'mocha/setup'

class ApiTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def random_name
    "test#{rand(10)}"
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

    container_name = random_name
    json = {:name => container_name}.to_json
    post '/containers/create', json, {'Content-Type' => 'application/json'}

    assert_equal '{"name":"'+container_name+'"}', last_response.body

  end

  def test_containers_start
    #Happy Path
    Rublix::LXC::Container.any_instance.stubs(:start).returns(true)
    post "/containers/#{random_name}/start"
    assert_equal 204, last_response.status

    #Error Path
    Rublix::LXC::Container.any_instance.stubs(:start).returns(false)
    post "/containers/#{random_name}/start"
    assert_equal 422, last_response.status

  end

  def test_containers_stop
    #Happy Path
    Rublix::LXC::Container.any_instance.stubs(:stop).returns(true)
    post "/containers/#{random_name}/stop"
    assert_equal 204, last_response.status

    #Error Path
    Rublix::LXC::Container.any_instance.stubs(:stop).returns(false)
    post "/containers/#{random_name}/stop"
    assert_equal 422, last_response.status

  end

  def test_containers_destroy
    #Happy Path
    Rublix::LXC::Container.any_instance.stubs(:destroy).returns(true)
    post "/containers/#{random_name}/destroy"
    assert_equal 204, last_response.status

    #Error Path
    Rublix::LXC::Container.any_instance.stubs(:destroy).returns(false)
    post "/containers/#{random_name}/destroy"
    assert_equal 422, last_response.status

  end

  def test_containers_reboot
    #Happy Path
    Rublix::LXC::Container.any_instance.stubs(:reboot).returns(true)
    post "/containers/#{random_name}/reboot"
    assert_equal 204, last_response.status

    #Error Path
    Rublix::LXC::Container.any_instance.stubs(:reboot).returns(false)
    post "/containers/#{random_name}/reboot"
    assert_equal 422, last_response.status

  end

  def test_containers_shutdown
    #Happy Path
    Rublix::LXC::Container.any_instance.stubs(:shutdown).returns(true)
    post "/containers/#{random_name}/shutdown"
    assert_equal 204, last_response.status

    #Error Path
    Rublix::LXC::Container.any_instance.stubs(:shutdown).returns(false)
    post "/containers/#{random_name}/shutdown"
    assert_equal 422, last_response.status

  end


end
