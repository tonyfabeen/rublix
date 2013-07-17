require 'rublix'
require 'test/unit'

class ProlixTest < Test::Unit::TestCase

  def test_lxc_config_path
    assert_equal Rublix::LXC.config_path, "/var/lxc/uga"
  end

  def test_new_container
    container = Rublix::LXC::Container.new("container_one")
    assert_equal container.name, "container_one"
  end
end
