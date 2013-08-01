require 'rake/testtask'

def print_message(msg)
  $stdout.puts "[Rublix] #{msg} "
end

def has_makefile?
  File.exists?(File.expand_path("./Makefile"))
end

Rake::TestTask.new do |t|
  t.libs << "."
  t.test_files = FileList['rublix_test.rb']
  t.verbose = true

end

task :clean do |t|
  print_message "Cleaning up ..."
  `make clean && rm Makefile` if has_makefile?
end

task :generate_makefile => [:clean] do |t|
  print_message "Generating Makefile ..."
  `ruby extconf.rb` unless has_makefile?
end


task :compile => [:generate_makefile] do |t|
  print_message "Compiling ..."
  `make`
end

task :install => [:compile] do |t|
  print_message "Installing ..."

  `make install`
  Rake::Task["test"].invoke

  print_message "All Tests Ok. Enjoy Rublix !!!"
end

