require 'rublix'
require 'test/unit'

class RublixTest < Test::Unit::TestCase

  def test_lxc_config_path
    lxc_config_path = "/var/lib/lxc"
    assert_equal Rublix::LXC.config_path, lxc_config_path
  end

  def test_get_version
    lxc_version_supported = "0.9.0"
    assert_equal Rublix::LXC.version, lxc_version_supported
  end

  def test_new_container
    container_name = "container_#{rand(999)}"
    puts "[Rublix Test] Creating #{container_name }"

    container = Rublix::LXC::Container.new(container_name)
    assert_equal container.name, container_name

    assert_equal container.create, true
    assert_equal container.is_defined, true
  end
end
