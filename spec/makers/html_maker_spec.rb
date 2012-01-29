require "spec_helper"
require "slim"
require "makers/html_maker"

describe HtmlMaker do
  before do
    @time_format = "%Y%m%d%H%M%S"
    @path = "."
    @time = Time.now.utc
    @revision = @time.strftime @time_format
    @files = %w(file1)
    @maker = HtmlMaker.new @path, @revision, @files
  end
  describe "when the html files are cleaned" do
    it "should remove the html files at previous revision" do
      File.should_receive(:exist?).with("#{@path}/#{@files.first}.html").and_return true
      File.should_receive(:delete).with *@files.map{|a| "#{@path}/#{a}.html"}
      @maker.clean
    end
    it "should only remove existing html files" do
      File.should_receive(:exist?).with("#{@path}/#{@files.first}.html").and_return false
      File.should_receive(:delete).with *[]
      @maker.clean
    end
  end
  describe "when the html files are made" do
    it "should make the html files to the current revision" do
      @mock_slim = mock "Slim"
      @mock_slim.should_receive(:render).with()
      @mock_slim.should_receive(:render).with(anything,{:page => @files.first, :revision => @revision})
      Slim::Template.should_receive(:new).with(/layout/).and_return @mock_slim
      Slim::Template.should_receive(:new).with("#{@path}/#{@files.first}.slim").and_return @mock_slim
      File.should_receive(:open).with("#{@path}/#{@files.first}.html","w")
      @maker.make
    end
  end
end
