require 'rublix'
require 'test/unit'

class ProlixTest < Test::Unit::TestCase

  def test_lxc_config_path
    assert_equal Rublix.lxc_config_path, "/var/lxc/uga"
  end
end
