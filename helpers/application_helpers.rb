module ApplicationHelpers
  def markdown(contents)
    renderer = Redcarpet::Render::HTML
    markdown = Redcarpet::Markdown.new(
      renderer,
      autolink: true,
      fenced_code_blocks: true,
      footnotes: true,
      highlight: true,
      smartypants: true,
      strikethrough: true,
      tables: true,
      with_toc_data: true
    )
    markdown.render(contents)
  end

  # Get the website name from site.yml
  def website_name
    data.site.name
  end

  # Get the title from frontmatter if any
  def frontmatter_title
    current_page.data.title
  end

  # If there's a title in frontmatter check if it's localized
  # and then join them with the website_name
  def local_title
    if frontmatter_title.is_a?(Hash) && frontmatter_title[I18n.locale]
      [frontmatter_title.send(I18n.locale), website_name].join(" - ")
    elsif frontmatter_title
      [frontmatter_title, website_name].join(" - ")
    end
  end

  # Page title is localized or title
  def page_title
    local_title || website_name
  end

  # Description is the value for description in frontmatter data
  # or the default value defined in site.yml
  def description
    current_page.data.description || t("site.description")
  end

  # Localized description value
  #
  # description:
  #   nl: "Dit is een beschrijving"
  #   en: "This is a description"
  #
  def localized_description
    description.send(I18n.locale) if description.is_a?(Hash) && description[I18n.locale]
  end

  # Meta description is localized_description or description
  def meta_description
    localized_description || description
  end

  # Robots is current page data or default
  def robots
    current_page.data.robots || "noydir,noodp,index,follow"
  end

  # Make custom page classes that don't translate from target_resource.path
  # Now we can target these pages with a single styling
  # Custom page classes
  def page_classes(path = current_path)
    path = current_resource.target_resource.path unless blog?
    classes = super(path.gsub("localizable", ""))

    if blog_index?
      # Replace `blog_#_index` with `blog_index`
      classes.sub!(/blog_\d+_index/, "blog_index")
    elsif is_blog_article?
      classes += " blog-article"
    elsif classes.include? "capp-entwickeln"
      # Replace `capp-entwickeln` with `capp-lms`
      classes.gsub!("capp-entwickeln", "capp-lms")
    end

    classes.prepend("#{I18n.locale} ")
  end

  # Get full url
  def full_url(url, locale = I18n.locale)
    base = "https://#{I18n.t('CNAME', locale: locale)}"
    URI.join(base, url).to_s
  end

  # Define image for Open Graph
  def og_image
    full_url(asset_url(current_page.data.image || "assets/images/social.png"))
  end

  # Get full locale (eg. nl_NL)
  def full_locale(lang = I18n.locale.to_s)
    case lang
    when "en"
      "en_US"
    else
      "#{lang.downcase}_#{lang.upcase}"
    end
  end

  # FILE_EXTENSION = /\.(\w+)$/.freeze

  # Url for current_page?
  def url_for_current_page(page = current_page)
    url_for(page.url, relative: false)
  end

  # Localized link_to
  def locale_link_to(*args, &block)
    url_arg_index = block_given? ? 0 : 1
    options_index = block_given? ? 1 : 2
    args[options_index] ||= {}
    options = args[options_index].dup
    args[url_arg_index] = locale_url_for(args[url_arg_index], options)
    link_to(*args, &block)
  end

  # Localized url_for
  def locale_url_for(url, options = {})
    locale = options[:locale] || I18n.locale
    options[:relative] = false
    url_parts = url.split("#")
    url_parts[0] = extensions[:i18n].localized_path(url_parts[0], locale) ||
                   url_parts[0]
    url = url_parts.join("#")
    url = url_for(url, options)
  end

  # Get the current_page or match on path starts_with
  def active_page?(path)
    arg_url = url_for(path.split("#")[0], relative: false)
    url_for_page = url_for_current_page()
    path_matches = url_for_page.start_with?(arg_url) && arg_url != "/"

    url_for_page == arg_url || path_matches
  end

  # Link_to with aria_current for active_page
  # https://github.com/thoughtbot/middleman-aria_current
  def current_link_to(*arguments, aria_current: "page", **options, &block)
    if block_given?
      text = capture(&block)
      path = arguments[0]
    else
      text = arguments[0]
      path = arguments[1]
    end

    link_options = options
    resource_path = path.delete("/")

    link_options["aria-current"] = aria_current if proxied_to == resource_path

    locale_link_to(text, path, link_options)
  end

  def locale_pretty_url(url, options = {})
    locale_url_for(url, options).gsub(".html", "/")
  end

  # Where's the current resource proxied to?
  def proxied_to
    if blog?
      "menu.html"
    else
      current_resource.target_resource.path.gsub("localizable/", "")
    end
  end

  # Get the other languages than current
  def other_locales
    langs - [I18n.locale]
  end

  # 404?
  def x404?
    current_page.url == "/404.html"
  end

  # Root url?
  def root_url?(page = current_page)
    page.url == "/"
  end

  # Blog?
  def blog?(page = current_page)
    page.url.start_with?("/menu/", "/en/menu/", "/nl/beers/", "/en/beers/")
  end

  # Blog index?
  def blog_index?(page = current_page)
    (page.url =~ %r{^\/blog\/(\d+\/)?$}).present?
  end
end
