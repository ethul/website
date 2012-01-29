require "spec_helper"
require "makers/css_maker"

describe CssMaker do
  before do
    @time_format = "%Y%m%d%H%M%S"
    @path = "."
    @time = Time.now.utc
    @revision = @time.strftime @time_format
    @files = %w(file1)
    @maker = CssMaker.new @path, @revision, @files
  end
  describe "when the css files are cleaned" do
    before do
      @past_revision1 = Time.at(@time.to_i - 1000).utc.strftime @time_format
      @past_revision2 = Time.at(@time.to_i - 2000).utc.strftime @time_format
      @future_revision1 = Time.at(@time.to_i + 4000).utc.strftime @time_format
      @future_revision2 = Time.at(@time.to_i + 5000).utc.strftime @time_format
    end
    it "should remove all css files older than the current revision" do
      glob = ["./#{@files.first}.#{@past_revision1}.css","./#{@files.first}.#{@past_revision2}.css"]
      Dir.should_receive(:glob).with("./assets/#{@files.first}.*.css").and_return glob
      File.should_receive(:delete).with *glob
      @maker.clean
    end
    it "should not remove css files at a newer revision than the current" do
      glob = ["./#{@files.first}.#{@future_revision1}.css","./#{@files.first}.#{@future_revision2}.css"]
      Dir.should_receive(:glob).with("./assets/#{@files.first}.*.css").and_return glob
      File.should_receive(:delete).with()
      @maker.clean
    end
    it "should only remove css files at a past revision than the current" do
      glob = ["./#{@files.first}.#{@future_revision1}.css","./#{@files.first}.#{@past_revision1}.css"]
      Dir.should_receive(:glob).with("./assets/#{@files.first}.*.css").and_return glob
      File.should_receive(:delete).with(glob.last)
      @maker.clean
    end
  end
  describe "when the css files are made" do
    before do
      @css1 = <<CSS
body {font-size: 1em;}
h1 {font-weight: bold;}
CSS
    end
    it "should make the css files named to the current revision" do
      IO.should_receive(:read).with("./assets/#{@files.first}.less").and_return @css1
      File.should_receive(:open).with("./assets/#{@files.first}.#{@revision}.css","w")
      @maker.make
    end
  end
end
