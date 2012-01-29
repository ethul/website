BASEPATH = File.absolute_path File.dirname(__FILE__) + "/.."
REVISION = Time.now.utc.strftime "%Y%m%d%H%M%S"
PAGES = %w(index cv)

$:.unshift BASEPATH + "/lib"
require "makers/css_maker"
require "makers/html_maker"

css_maker = CssMaker.new BASEPATH, REVISION, PAGES
html_maker = HtmlMaker.new BASEPATH, REVISION, PAGES

[css_maker, html_maker].each do |maker|
  puts "#{maker.class.name} running clean"
  maker.clean
  puts "#{maker.class.name} running make"
  maker.make
end

puts "Done."
