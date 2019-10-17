# frozen_string_literal: true

# Determine root locale
root_locale = (ENV["LOCALE"] ? ENV["LOCALE"].to_sym : :nl)
# Accessible as `root_locale` in helpers and `config[:root_locale]` in templates
set :root_locale, root_locale

# Activate i18n for root locale
activate :i18n, mount_at_root: root_locale, langs: %i[nl en]
activate :autoprefixer
activate :directory_indexes
activate :inline_svg
activate :sprockets

# Set Google Analytics id
set :ga_code, "UA-24956010-4"

# Ignore the selection file for Icomoon
ignore "assets/fonts/selection.json"

set :css_dir, "assets/stylesheets"
set :fonts_dir, "assets/fonts"
set :images_dir, "assets/images"
set :js_dir, "assets/javascripts"

# Use kramdown for markdown
# https://kramdown.gettalong.org/
set :markdown_engine, :kramdown
set :markdown, input: "GFM",
               auto_ids: true

# Without layout
page "/*.json", layout: false
page "/*.txt", layout: false
page "/*.xml", layout: false

# Settings for production
configure :production do

  activate :asset_hash, ignore: ["assets/images/maps-marker.png"]
  # activate :gzip
  activate :minify_css
  activate :minify_html
  activate :minify_javascript

  # Raise exception for missing translations during build
  require "lib/test_exception_localization_handler"

  I18n.exception_handler = TestExceptionLocalizationHandler.new
end
