require "less"

class CssMaker
  def initialize
    @output_path = "../assets"
    @files = ["index","cv"]
    @input_paths = ["../assets"]
    @parser = Less::Parser.new :paths => @input_paths
  end

  def make revision
    @files.each do |file|
      result = @parser.parse("@import '#{file}.less';").to_css(:compress => true)
      File.open("#{@output_path}/#{file}.#{revision}.css","w") do |output|
        output.puts result
      end
    end
  end

  def clean
  end
end
