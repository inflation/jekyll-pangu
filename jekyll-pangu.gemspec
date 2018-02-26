lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'jekyll-pangu/version'
Gem::Specification.new do |s|
  s.name = 'jekyll-pangu'
  s.version = Jekyll::Pangu::VERSION
  s.date = '2018-02-26'
  s.summary = 'Integration of Pangu with Jekyll'
  s.description = 'Automatically add spacing between CJK and ' \
                  'other characters for all your Jekyll posts'
  s.authors = ['Inflation']
  s.email = ['hypernovagama@gmail.com']
  s.homepage = 'https://github.com/inflation/jekyll-pangu'
  s.licenses = ['MIT']
  s.files = `git ls-files -z`
               .split("\x0")
               .reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.require_paths = ['lib']
  s.add_dependency 'jekyll', '~> 3.0'
end
