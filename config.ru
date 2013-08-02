require File.expand_path './api/app'
# RUN App : sudo rackup -r ./api/app.rb -p 6000
run Sinatra::Application
