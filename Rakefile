# Serve
task :serve do
  puts "*"*50
  puts "Serving Just in Beer!"
  puts "*"*50
  system "bundle exec middleman"
end

# Build
task :build do
  puts "*"*50
  puts "Brewing Beer!"
  puts "*"*50
  system "bundle exec middleman build --clean" or exit(1)
end

# Test
task :test do
  begin
    Rake::Task["build"].invoke
  rescue SystemExit => e
    puts "*"*50
    puts "* Brew failed, abort drinking"
    puts "*"*50
    exit(e.status)
  end

  puts "*"*50
  puts "* Brew successful, Drinking Beer ... "
  puts "*"*50
  system "ruby test.rb" or exit(1)
end

# Deploy
task :deploy do
  begin
    Rake::Task["build"].invoke
  rescue SystemExit => e
    puts "*"*50
    puts "* Brew failed, abort drinking"
    puts "*"*50
    exit(e.status)
  end

  puts "*"*50
  puts "* Brew successful, Drinking Beer ... "
  puts "*"*50
  system "bundle exec middleman deploy" or exit(1)
end
