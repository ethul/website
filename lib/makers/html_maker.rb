require "slim"

class HtmlMaker
  def initialize
    @input_path = ".."
    @output_path = ".."
    @files = ["index2"]
  end

  def make revision
    @files.each do |file|
      result = Slim::Template.new("#{@input_path}/layout.slim").render(Object.new,:page => file, :revision => revision) {
        Slim::Template.new("#{@input_path}/#{file}.slim").render
      }
      File.open("#{@output_path}/#{file}.html","w") do |output|
        output.puts result
      end
    end
  end

  def clean
  end
end
