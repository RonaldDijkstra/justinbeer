# frozen_string_literal: true

require "net/http"
require "uri"
require "yaml"
require "json"
require "fileutils"

uri = URI.parse("https://business.untappd.com/api/v1/sections/350873/items")
request = Net::HTTP::Get.new(uri)
request["Authorization"] = "Basic anVzdF9pbl9iZWVyQGhvdG1haWwuY29tOlBIeEFUdHJZejZReGh5cjRCc1Zm"

req_options = {
  use_ssl: uri.scheme == "https"
}

response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end

if response.code == "200"

  # File.open("data/full_menu.yml", "w") do |f|
  #   f.write(JSON.parse(response.body).to_yaml)
  #   f.close
  # end

  if Dir.exist?("source/menu/nl/")
    FileUtils.rm_rf("source/menu/nl/.", secure: true)
  else
    FileUtils.mkdir_p("source/menu/nl/")
  end

  if Dir.exist?("source/menu/en/")
    FileUtils.rm_rf("source/menu/en/.", secure: true)
  else
    FileUtils.mkdir_p("source/menu/en/")
  end

  result = JSON.parse(response.body, object_class: OpenStruct)

  result.items.each do |doc|
    File.open("source/menu/nl/#{doc.untappd_beer_slug}.html.markdown", "w") do |f|
      f.write("---\n")
      f.write("title: \"#{doc.name}\"\n")
      f.write("date: #{doc.updated_at}\n")
      f.write("style: \"#{doc.style}\"\n")
      f.write("brewery: \"#{doc.brewery}\"\n")
      f.write("image: \"#{doc.label_image}\"\n")
      f.write("rating: \"#{doc.rating.to_f.round(2)}\"\n")
      f.write("description: \"#{doc.description.gsub(/\n/, " ").gsub(/"/, " ")}\"\n")
      f.write("untappd_url: \"https://untappd.com/b/#{doc.untappd_beer_slug}/#{doc.untappd_id}\"\n")
      f.write("abv: \"#{doc.abv}\"\n")
      f.write("ibu: \"#{doc.ibu.to_f.round(0)}\"\n")
      f.write("robots: noindex,nofollow\n")
      f.write("---\n")
      f.close
    end
    FileUtils.cp("source/menu/nl/#{doc.untappd_beer_slug}.html.markdown", "source/menu/en/")
  end
else
  puts "Error retrieving data"
end
