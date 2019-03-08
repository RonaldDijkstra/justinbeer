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

# Ignore the selection file for Icomoon
ignore "assets/fonts/selection.json"

set :css_dir, "assets/stylesheets"
set :fonts_dir, "assets/fonts"
set :images_dir, "assets/images"
set :js_dir, "assets/javascripts"
set :markdown,
  autolink: true,
  fenced_code_blocks: true,
  footnotes: true,
  highlight: true,
  smartypants: true,
  strikethrough: true,
  tables: true,
  with_toc_data: true
set :markdown_engine, :redcarpet

activate :blog do |blog|
  blog.name = "menu"
  blog.sources = "/menu/:lang/:title.html"
  blog.permalink = ":lang/beers/:title"
  blog.paginate = true
  blog.page_link = "{num}"
  blog.per_page = 50
end

# Without layout
page "/*.json", layout: false
page "/*.txt", layout: false
page "/*.xml", layout: false

# Settings for production
configure :production do
  activate :asset_hash
  activate :gzip
  activate :minify_css
  activate :minify_html
  activate :minify_javascript

  # Raise exception for missing translations during build
  require "lib/test_exception_localization_handler"

  I18n.exception_handler = TestExceptionLocalizationHandler.new
end
