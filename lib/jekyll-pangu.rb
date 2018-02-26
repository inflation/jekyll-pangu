# coding: utf-8

require 'jekyll'
require 'jekyll-pangu/pangu'

=begin
Add a hook to automatically convert posts, pages and documents with their 'page.lang' setting to CJK, i.e., starting with zh, jp, or ko.
TODO: Give an option to enable globally

Also provide a filter to manually call the function in templates.
=end

module JekyllPangu
  module PanguFilter
    def pangu(input)
      Pangu.spacing(input)
    end
  end

  Jekyll::Hooks.register [:posts, :pages, :documents], :pre_render do |post|
    if post.data['lang'] =~ /^(zh|jp|ko)/
      post.data['title'] = spacing(post.data['title'])
      post.data['excerpt'].output = spacing(post.data['excerpt'].to_s)
      post.content = spacing(post.to_s)
    end
  end
end

Liquid::Template.register_filter(JekyllPangu::PanguFilter)
