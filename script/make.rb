require "makers/css_maker"
require "makers/html_maker"

BASEPATH = File.dirname(__FILE__)
REVISION = Time.now.utc.strftime "%Y%m%d%H%M%S"

[CssMaker.new, HtmlMaker.new].each do |maker|
  puts "Making with #{maker.class.name}"
  maker.make REVISION
end

puts "Done."
