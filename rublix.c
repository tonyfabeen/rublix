#include <ruby.h>
#include <string.h>
#include <lxc/lxccontainer.h>

static VALUE mRublix;
static VALUE mLxc;
static VALUE cContainer;

static VALUE get_version(VALUE self){
  const char *lxc_version = lxc_get_version();
  return rb_str_new2(lxc_version);
}

static VALUE lxc_config_path(VALUE klass){
  VALUE str_config_path;
  const char *config_path = lxc_get_default_config_path();
  str_config_path = rb_str_new2(config_path);
  return str_config_path;
}

static VALUE container_new(VALUE container_class,
                           VALUE container_name){
  VALUE args[1];
  struct lxc_container *c;

  c = lxc_container_new((const char *) container_name, NULL);
  if (!c) {
    fprintf(stderr, "Error on create container)");
  }

  VALUE tdata = Data_Wrap_Struct(container_class, 0, free, c);
  args[0] = container_name;

  rb_obj_call_init(tdata,1,args);
  return tdata;
}

static VALUE container_init(VALUE self, VALUE container_name){
  rb_iv_set(self, "@name", container_name);
  return self;
}


static VALUE container_get_name(VALUE self){
  return rb_iv_get(self,"@name");
}


static VALUE container_is_defined(VALUE self){
  struct lxc_container *c;
  Data_Get_Struct(self, struct lxc_container, c);

  if(c->is_defined(c)){
    return Qtrue;
  }else{
    return Qfalse;
  }
}


static VALUE container_create(VALUE self){
  struct lxc_container *c;
  Data_Get_Struct(self, struct lxc_container, c);

  if(!c->set_config_item(c, "lxc.network.type", "veth")){
    fprintf(stderr, "[Rublix] Error on setting network type");
  }
  rb_iv_set(self, "@network_type", rb_str_new2("veth"));

  if(c->createl(c, "ubuntu", NULL, NULL, 0, "-r", "lucid", NULL)){
    return Qtrue;
  }else{
    return Qfalse;

  }

}


void Init_rublix(){

  mRublix = rb_define_module("Rublix");
  mLxc    = rb_define_module_under(mRublix, "LXC");
  rb_define_singleton_method(mLxc, "config_path", lxc_config_path, 0);
  rb_define_singleton_method(mLxc, "version", get_version, 0);

  cContainer = rb_define_class_under(mLxc, "Container", rb_cObject);
  rb_define_singleton_method(cContainer, "new", container_new,1);
  rb_define_method(cContainer, "initialize", container_init, 1);
  rb_define_method(cContainer, "name", container_get_name,0);
  rb_define_method(cContainer, "is_defined", container_is_defined, 0);
  rb_define_method(cContainer, "create", container_create,0);

}

