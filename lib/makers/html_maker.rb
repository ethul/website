require "slim"

class HtmlMaker
  def initialize path, revision, files
    @path = path
    @layout = "#{path}/layout.slim"
    @revision = revision
    @files = files
  end

  def make
    @files.each do |file|
      result = render_layout @layout, layout_scope(file,@revision), render_page(@path,file)
      File.open("#{@path}/#{file}.html","w") do |output|
        output.puts result
      end
    end
  end

  def clean
    File.delete *existing_html_files(@files)
  end

  private
  def render_page path, file
    Slim::Template.new("#{path}/#{file}.slim").render
  end

  def render_layout layout, scope, page
    Slim::Template.new(layout).render(*scope) {page}
  end

  def layout_scope file, revision
    [Object.new, :page => file, :revision => revision]
  end

  def existing_html_files files
    files.map {|a| "#{@path}/#{a}.html"}.
      select {|a| File.exist? a}
  end
end
