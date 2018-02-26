# coding: utf-8

=begin
The module Pangu is copied from the repo: https://github.com/dlackty/pangu.rb under MIT License. Then modified to use unicode '\u2006', i.e., "SIX-PER-EM SPACE" for better looking, as well as ignoring backquote '`' since it will be handled by <code> tags.
=end

module Pangu
  CJK_QUOTE_L_RE = /([\u3040-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])(["\'])/i
  CJK_QUOTE_R_RE = /(["\'])([\u3040-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])/i
  CJK_QUOTE_FIX_RE = /(["\']+)(\s*)(.+?)(\s*)(["\']+)/i

  CJK_BRACKET_RE = /([\u3040-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])([<\[\{\(]+(.*?)[>\]\}\)]+)([\u3040-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])/i
  CJK_BRACKETFIX_RE = /([<\[\{\(]+)(\s*)(.+?)(\s*)([>\]\}\)]+)/i
  CJK_BRACKET_L_RE = /([\u3040-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])([<>\[\]\{\}\(\)])/i
  CJK_BRACKET_R_RE = /([<>\[\]\{\}\(\)])([\u3040-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])/i

  CJK_HASH_L_RE = /([\u3040-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])(#(\S+))/i
  CJK_HASH_R_RE = /((\S+)#)([\u3040-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])/i

  CJK_L_RE = /([\u3040-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])([a-z0-9@&%=\$\^\*\-\+\|\/\\])/i
  CJK_R_RE = /([a-z0-9~!%&=;\|\,\.\:\?\$\^\*\-\+\/\\])([\u3040-\u312f\u3200-\u32ff\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff])/i

  def self.spacing(text)
    text = text.dup

    text.gsub!(CJK_QUOTE_L_RE, "\\1\u2006\\2")
    text.gsub!(CJK_QUOTE_R_RE, "\\1\u2006\\2")
    text.gsub!(CJK_QUOTE_FIX_RE, "\\1\\3\\5")

    old_text = text
    new_text = old_text.gsub(CJK_BRACKET_RE, "\\1\u2006\\2\u2006\\4")
    text = new_text

    if old_text == new_text
      text.gsub!(CJK_BRACKET_L_RE, "\\1\u2006\\2")
      text.gsub!(CJK_BRACKET_R_RE, "\\1\u2006\\2")
    end

    text.gsub!(CJK_BRACKETFIX_RE, "\\1\\3\\5")

    text.gsub!(CJK_HASH_L_RE, "\\1\u2006\\2")
    text.gsub!(CJK_HASH_R_RE, "\\1\u2006\\3")

    text.gsub!(CJK_L_RE, "\\1\u2006\\2")
    text.gsub!(CJK_R_RE, "\\1\u2006\\2")

    text
  end
end

=begin
Add a hook to automatically convert posts, pages and documents with their 'page.lang' setting to CJK, i.e., starting with zh, jp, or ko.
TODO: Give an option to enable globally

Also provide a filter to manually call the function in templates.
=end

module Jekyll
  module PanguFilter
    def pangu(input)
      Pangu.spacing(input)
    end
  end

  Jekyll::Hooks.register [:posts, :pages, :documents], :pre_render do |post|
    if post.data['lang'] =~ /^(zh|jp|ko)/
      post.data['title'] = Pangu.spacing(post.data['title'])
      post.data['excerpt'].output = Pangu.spacing(post.data['excerpt'].to_s)
      post.content = Pangu.spacing(post.to_s)
    end
  end
end

Liquid::Template.register_filter(Jekyll::PanguFilter)
