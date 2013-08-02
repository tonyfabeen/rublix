require 'rake/testtask'

APP_DIR = Dir.pwd
EXT_DIR = APP_DIR + '/ext/rublix'
TEST_DIR = APP_DIR + '/test'

def print_message(msg)
  $stdout.puts "[Rublix] #{msg} "
end

def has_makefile?
  File.exists?("./Makefile")
end

Rake::TestTask.new do |t|
  t.libs << "."
  t.test_files = FileList["#{TEST_DIR}/rublix_test.rb", "#{TEST_DIR}/api_test.rb"]
  t.verbose = true

end

task :clean do |t|
  print_message "Cleaning up ..."
  system("make clean && rm Makefile") if has_makefile?
end

task :generate_makefile => [:clean] do |t|
  print_message "Generating Makefile ..."
  system("ruby #{EXT_DIR}/extconf.rb") unless has_makefile?
end


task :compile => [:generate_makefile] do |t|
  print_message "Compiling ..."
  system("make")
end

task :install => [:compile] do |t|
  print_message "Installing ..."

  system("cd #{EXT_DIR} && make install")
  Rake::Task["test"].invoke

  print_message "All Tests Ok. Enjoy Rublix !!!"
end

