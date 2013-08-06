Rublix
======

LXC Management Tool in Ruby

## Requirements
  - Ubuntu 11.04 / 11.10 64-bit system
  - Superuser privileges
  - Ruby 1.9.x
  - Ubuntu Packages : lxc, lxc-dev >= 0.9.0
  - RubyGems : Bundler, Sinatra

## Testing and Running

 I suppose you are using a new machine.

 ```sh
   $ chmod +x ./scripts/prepare_environment
   $ sudo ./scripts/prepare_environment
   $ bundle install
   $ sudo rake install
   $ sudo ./bin/rublix &
 ```

## TODO

* Use other Distro templates. Today it supports only Ubuntu Machines.
* Set another user/password than what comes with template.

