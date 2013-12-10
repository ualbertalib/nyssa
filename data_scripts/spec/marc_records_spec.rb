require "marc"
require_relative "spec_helper.rb"

describe MarcRecords do
  
  # Probably should mock the data file  object here...
  let(:marc_records){  MarcRecords.new("spec/data/test_data.xml") }

  it "should populate a list with marc records" do
    marc_records.list.size.should be > 0
  end

  context "given a populated list of records, each record" do
    it "should be a Record" do
      expect(marc_records.list[0]).to be_an_instance_of Record
    end
  end
end
