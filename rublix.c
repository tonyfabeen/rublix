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
  const char *name = StringValuePtr(container_name);

  c = lxc_container_new(name, NULL);
  if (!c) {
    fprintf(stderr, "[Rublix C Ext] Error on create container\n)");
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

static VALUE container_pid(VALUE self){
  struct lxc_container *c;
  Data_Get_Struct(self, struct lxc_container, c);
  char *pid_str;
  sprintf(pid_str, "%ld", (long) c->init_pid);

  return rb_str_new2(pid_str);
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

static VALUE container_is_running(VALUE self) {
  struct lxc_container *c;
  Data_Get_Struct(self, struct lxc_container, c);

  if(c->is_running(c)){
    return Qtrue;
  }else{
    return Qfalse;
  }
}

static VALUE container_create(VALUE self){
  struct lxc_container *c;
  Data_Get_Struct(self, struct lxc_container, c);
  const char *network_type = "veth";
  const char *network_link = "lxcbr0";
  const char *network_flags = "up";

  if(!c->set_config_item(c, "lxc.network.type", network_type)){
    fprintf(stderr, "[Rublix C Ext] Error on setting network type\n");
  }

  if(!c->set_config_item(c, "lxc.network.link", network_link)){
    fprint(stderr, "[Rublix C Ext] Error on setting network link\n");
  }

  if(!c->set_config_item(c, "lxc.network.flags",network_flags)){
    fprintf(stderr, "[Rublix C Ext] Error on setting network flags\n");
  }

  rb_iv_set(self, "@network_type", rb_str_new2("veth"));
  rb_iv_set(self, "@network_link", rb_str_new2("lxcbr0"));
  rb_iv_set(self, "@network_flags", rb_str_new2("up"));

  if(c->createl(c, "ubuntu", NULL, NULL, 0, "-r", "lucid", NULL)){
    return Qtrue;
  }else{
    return Qfalse;
  }
}


static VALUE container_start(VALUE self){
  struct lxc_container *c;
  Data_Get_Struct(self, struct lxc_container, c);

  c->load_config(c, NULL);
  c->want_daemonize(c);

  if(c->startl(c,0,NULL)){
    fprintf(stdout,"[Rublix C Ext] Container Started Successflly!!\n");
    return Qtrue;
  }else{
    fprintf(stderr,"[Rublix C Ext] Error on trying to Start Container\n");
    return Qfalse;
  }
}

static VALUE container_stop(VALUE self){
  struct lxc_container *c;
  Data_Get_Struct(self, struct lxc_container, c);

  if(c->stop(c)){
    fprintf(stdout,"[Rublix C Ext] Container Stopped Successflly!!\n");
    return Qtrue;
  }else{
    fprintf(stderr,"[Rublix C Ext] Error on trying to Stop Container\n");
    return Qfalse;
  }
}

static VALUE container_destroy(VALUE self) {
  struct lxc_container *c;
  Data_Get_Struct(self, struct lxc_container, c);

  if(c->destroy(c)){
    fprintf(stdout,"[Rublix C Ext] Container Destroyed Successflly!!\n");
    return Qtrue;
  }else{
    fprintf(stderr,"[Rublix C Ext] Error on trying to Destroy Container\n");
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
  //rb_define_method(cContainer, "pid", container_pid,0);
  rb_define_method(cContainer, "name", container_get_name,0);
  rb_define_method(cContainer, "is_defined?", container_is_defined, 0);
  rb_define_method(cContainer, "is_running?", container_is_running,0);
  rb_define_method(cContainer, "create", container_create,0);
  rb_define_method(cContainer, "start", container_start,0);
  rb_define_method(cContainer, "stop", container_stop,0);
  rb_define_method(cContainer, "destroy", container_destroy,0);

}

