#include <ruby.h>
//#include <lxc/lxccontainer.h>

#define CONTAINER_NAME "containerone"

static VALUE mRublix;
static VALUE mLxc;
static VALUE cContainer;
struct lxc_container
{
  char *name;
};

static VALUE lxc_config_path(VALUE klass){
  VALUE str_config_path;
  /*
  //lxc_get_default_config_path()
  struct lxc_container *c;

  if ((c = lxc_container_new(CONTAINER_NAME, NULL)) == NULL){
    fprintf(stderr, "[PROLIX] : Error on create a container");
  }
  */

  str_config_path = rb_str_new2("/var/lxc/uga");
  return str_config_path;
}

static VALUE lxc_container_new(VALUE container_class, 
                               VALUE container_name){
  VALUE arg_name[1];
  //
  struct lxc_container *c;

  c = malloc(sizeof(*c));
  if (!c) {
    fprintf(stderr, "Error on create container)");
  }

  VALUE tdata = Data_Wrap_Struct(container_class, 0, free, c);
  arg_name[0] = container_name;

  rb_obj_call_init(tdata,1,arg_name);
  return tdata;
}

static VALUE lxc_container_init(VALUE self, VALUE container_name){
  rb_iv_set(self, "@name", container_name);
  return self;
}

static VALUE lxc_container_get_name(VALUE self){
  return rb_iv_get(self,"@name");
}

void Init_rublix(){
  mRublix = rb_define_module("Rublix");
  mLxc    = rb_define_module_under(mRublix, "LXC");
  rb_define_singleton_method(mLxc, "config_path", lxc_config_path, 0);

  cContainer = rb_define_class_under(mLxc, "Container", rb_cObject); 
  rb_define_singleton_method(cContainer, "new", lxc_container_new,1);
  rb_define_method(cContainer, "initialize", lxc_container_init, 1);
  rb_define_method(cContainer, "name", lxc_container_get_name,0);
}

