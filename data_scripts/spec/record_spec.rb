require_relative "spec_helper"

describe Record do

  before :each do
    @record = Record.new
  end

  describe "#new" do
    
    it "should include other instance variables" do
      variables = @record.instance_variables
      variables.should include(:@catkey)
      variables.should include(:@pubDateNotes)
      variables.should include(:@updated)
      variables.should include(:@bad_dates)
      variables.should include(:@bad_issn_statement) # derive bad_issn, no_issn
      variables.should include(:@no_url)
      variables.should include(:@date_statement)
      variables.should include(:@holdings_comparison)
    end

    it "should include a MarcRecord object" do
      @record.marc_record.should be_an_instance_of MarcRecord
    end
  end

  describe "#expand!" do
    # this should test all expanded attributes
    it "should populate the catkey from the marc_record" do
      marc_records = MarcRecords.new
      marc_records.load_data("spec/test_data.xml")
      @record.marc_record=marc_records.list[0]
      @record.expand!
      @record.catkey.should == "5903768" 
    end
  end

  describe "#single_target" do
    it "should return whether a record has only one target" do
      marc_records = MarcRecords.new
      marc_records.load_data("spec/test_data.xml")
      @record.marc_record=marc_records.list[0]
      @record.single_target.should be_false
    end
  end
end
