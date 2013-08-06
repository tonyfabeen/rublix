require 'rublix'
require 'test/unit'

class RublixTest < Test::Unit::TestCase

  def create_container
    container_name = "container#{rand(111)}"
    container = Rublix::LXC::Container.new(container_name)
    container.create
    container
   end

  def test_lxc_config_path
    lxc_config_path = "/var/lib/lxc"
    assert_equal Rublix::LXC.config_path, lxc_config_path
  end

  def test_get_version
    lxc_version_supported = "0.9.0"
    assert_equal Rublix::LXC.version, lxc_version_supported
  end

  def test_new_container
    container_name = "container#{rand(111)}"
    puts "[Rublix Test] Creating #{container_name }"

    container = Rublix::LXC::Container.new(container_name)
    assert_equal container.name, container_name
      assert_equal container.running?, false

    assert_equal container.create, true
    assert_equal container.defined?, true

    puts "[Rublix Test] Starting #{container_name }"
    assert_equal container.start, true
    assert_equal container.running?, true
    assert_equal Dir.exists?("/var/lib/lxc/#{container_name}"), true

    puts "[Rublix Test] Stoping #{container_name}"
    assert_equal container.stop, true
    assert_equal container.running?, false

    puts "[Rublix Test] Destroying #{container_name}"
    assert_equal container.destroy, true
    assert_equal container.running?, false
    assert_equal Dir.exists?("/var/lib/lxc/#{container_name}"), false
  end


  def test_get_config_item
    container = create_container
    puts "[Rublix Test] Config For #{container.name}"

    assert_equal container.get_config_item("lxc.utsname"), container.name
    assert_equal container.get_config_item("lxc.rootfs"), "/var/lib/lxc/#{ container.name}/rootfs"

    container.destroy
  end

  def test_get_cgroup_item
    container = create_container
    puts "[Rublix Test] Get CGROUP Item For #{container.name}"
    container.start

    puts "[Rublix Test] CGROUP Get Item 'cpuset.cpus' #{container.get_cgroup_item("cpuset.cpus")}"
    #same as $ cat /sys/fs/cgroup/cpuset/lxc/<container_name>/cpuset.cpus
    assert_not_nil container.get_cgroup_item("cpuset.cpus")

    container.stop
    container.destroy
  end

  def test_set_cgroup_item
    container = create_container
    puts "[Rublix Test] Set CGROUP Item For #{container.name}"
    container.start

    container.set_cgroup_item("cpuset.cpus", "0")
    #Lxc puts \n in the end :(
    assert_equal container.get_cgroup_item("cpuset.cpus"), "0\n"

    container.stop
    container.destroy
  end

  def test_shutdown_container
    container = create_container
    puts "[Rublix Test] Shutdown #{container.name}"
    container.start

    assert_equal container.running?, true
    assert_equal container.shutdown, true
    assert_equal container.running?, false

    container.destroy

  end

  def test_reboot_container
    container = create_container
    puts "[Rublix Test] Reboot #{container.name}"
    container.start

    assert_equal container.running?, true
    assert_equal container.reboot, true

    container.stop
    container.destroy
  end

end
