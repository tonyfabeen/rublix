require 'mkmf'

have_library('lxc')
have_header('lxc/lxccontainer.h')
have_func('lxc_get_default_config_path', 'lxc/lxccontainer.h')
create_makefile('rublix')
