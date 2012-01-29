require "less"

class CssMaker
  def initialize path, revision, files
    @path = "#{path}/assets"
    @revision = revision
    @files = files
    @parser = Less::Parser.new :paths => [@path]
  end

  def make
    @files.each do |file|
      result = @parser.parse(read_less_file @path, file).to_css(:compress => true)
      File.open(css_file_name(@path,file,@revision),"w") do |output|
        output.puts result
      end
    end
  end

  def clean
    @files.each do |file|
      File.delete *find_old_revisions(@path, file, @revision)
    end
  end

  private
  def read_less_file path, file
    IO.read("#{path}/#{file}.less")
  end

  def css_file_name path, file, revision
    "#{@path}/#{file}.#{@revision}.css"
  end

  def find_old_revisions path, file, revision
    Dir.glob("#{path}/#{file}.*.css").
      select {|a| older_revision? a, revision}
  end

  def older_revision? file, revision
    extract_timestamp(file).to_i < revision.to_i
  end

  def extract_timestamp file
    file.split(".")[-2].to_i
  end
end
