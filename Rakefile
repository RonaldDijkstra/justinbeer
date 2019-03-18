# frozen_string_literal: true

require_relative "./lib/colorizer"

## What's this sourcery
def project_name
  "Just in Beer 2019 🍺"
end

## Serve
namespace :serve do
  def serve
    puts "== Start server..."
    system "bundle exec middleman serve" || exit(1)
  end

  task :data do
    puts "== Project: " + project_name.green
    puts "== Retrieving external data..."
    system "ruby lib/untappd_menu.rb" || exit(1)
    puts "== Retrieved external data".green
    serve
  end

  task :clean do
    puts "== Project: " + project_name.green
    serve
  end
end

## Build the website
task :build do
  puts "== Project: " + project_name.green
  puts "== Retrieving external data..."
  system "ruby lib/untappd_menu.rb" || exit(1)
  puts "== Retrieved external data".green
  puts "== Brewing...".green
  system "bundle exec middleman build" || exit(1)
  FileUtils.rm_rf("build/en/beers/", verbose: true)
  FileUtils.rm_rf("build/nl/", verbose: true)
end

## Build & Proof
task :proof do
  puts "== Project: " + project_name.green
  puts "== Brewing in verbose mode...".green
  system "bundle exec middleman build --verbose" || exit(1)
  FileUtils.rm_rf("build/en/beers/", verbose: true)
  FileUtils.rm_rf("build/nl/", verbose: true)
  # Run html-proofer with options
  puts "== Proofing the brew...".green
  system "ruby lib/html_proofer.rb" || exit(1)
end

def git_branch_name
  `git rev-parse --abbrev-ref HEAD`
end

desc "Submits PR to GitHub"
task :pr do
  branch_name = git_branch_name
  if branch_name == "master"
    puts "On master branch, not PRing."
    exit 1
  end

  `git push -u origin #{branch_name}`
  `open https://github.com/RonaldDijkstra/justinbeer/compare/#{branch_name}`
end
