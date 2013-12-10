require "marc"
require_relative "spec_helper.rb"

RSpec.configure do |c|
  c.include TestData
end

describe MarcRecords do
  
  # Probably should mock the data file  object here...
  let(:marc_records){  MarcRecords.new(StringIO.new(single_record)) }

  it "should populate a list with marc records" do
    marc_records.list.size.should be > 0
  end

  context "given a populated list of records, each record" do
    it "should be a Record" do
      expect(marc_records.list[0]).to be_an_instance_of Record
    end
  end
end
