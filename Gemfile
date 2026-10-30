source 'https://rubygems.org'

ruby '>= 3.3'

gem 'jekyll', '4.4.1'

# Core plugins that directly affect site building
group :jekyll_plugins do
    gem 'jekyll-archives-v2', '0.0.8'
    gem 'jekyll-email-protect', '1.1.0'
    gem 'jekyll-feed', '0.18.0'
    gem 'jekyll-get-json', '1.0.0'
    gem 'jekyll-imagemagick', '1.4.0'
    gem 'jekyll-jupyter-notebook', '0.0.6'
    gem 'jekyll-link-attributes', '2.0.1'
    gem 'jekyll-minifier', '0.2.2'
    gem 'jekyll-paginate-v2', '3.0.0'
    gem 'jekyll-regex-replace', '1.1.0'
    gem 'jekyll-scholar', '7.3.0'
    gem 'jekyll-sitemap', '1.4.0'
    gem 'jekyll-tabs', '1.2.1'
    gem 'jekyll-terser', git: "https://github.com/RobertoJBeltran/jekyll-terser.git", ref: "1085bf66d692799af09fe39f8162a1e6e42a3cc4"
    gem 'jekyll-toc', '0.19.0'
    gem 'jekyll-twitter-plugin', '2.1.0'
    gem 'jemoji', '0.13.0'

    gem 'classifier-reborn', '2.3.0'  # used for content categorization during the build
end

# Gems for development or external data fetching (outside :jekyll_plugins)
group :other_plugins do
    gem 'css_parser', '3.3.0'
    gem 'feedjira', '4.0.1'
    gem 'httparty', '0.24.2'
    gem 'observer', '0.1.2'       # used by jekyll-scholar
    gem 'ostruct', '0.6.3'        # used by jekyll-twitter-plugin
    # gem 'terser'         # used by jekyll-terser
    # gem 'unicode_utils' -- should be already installed by jekyll
    # gem 'webrick' -- should be already installed by jekyll
end
