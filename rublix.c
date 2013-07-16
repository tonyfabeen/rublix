#include <ruby.h>
//#include <lxc/lxccontainer.h>

#define CONTAINER_NAME "containerone"

static VALUE mRublix;

static VALUE lxc_config_path(VALUE klass){
  VALUE str_config_path;
  /*
  struct lxc_container *c;

  if ((c = lxc_container_new(CONTAINER_NAME, NULL)) == NULL){
    fprintf(stderr, "[PROLIX] : Error on create a container");
  }
  */

  str_config_path = rb_str_new2("/var/lxc/uga");
  return str_config_path;
}

void Init_rublix(){
  mRublix = rb_define_module("Rublix");
  rb_define_singleton_method(mRublix, "lxc_config_path", lxc_config_path, 0);
}

