require "marc"
require_relative "spec_helper.rb"

describe MarcRecords do

  before :each do
    @marc_records = MarcRecords.new
  end

  describe "#new" do
    it "should return a MarcRecords.object" do
      @marc_records.should be_an_instance_of MarcRecords
    end

    it "should contain an array of marc records" do
      @marc_records.list.should be_an_instance_of Array
    end
  end

  describe "#load_data" do
    before { @marc_records.load_data("spec/test_data.xml") }
    it "should load marc data into the list" do
      @marc_records.list.size.should be > 0
    end
    it "the list should contain MarcRecord objects" do
      @marc_records.list[0].should be_an_instance_of Record::MarcRecord
    end

    it "should populate a list of targets" do
      @marc_records.list[0].targets.size.should be > 0
    end
  end
end
