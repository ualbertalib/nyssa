require_relative "spec_helper"

describe Record do

  before :each do
    @record = Record.new
  end

  describe "#new" do
    
    it "should include other instance variables" do
      variables = @record.instance_variables
      variables.should include(:@catkey)
      variables.should include(:@updated)
      variables.should include(:@bad_dates)
      variables.should include(:@bad_issn_statement) # derive bad_issn, no_issn
      variables.should include(:@no_url)
      variables.should include(:@date_statement)
      variables.should include(:@match_statement)
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
      @record.marc_record=marc_records.list.last
      @record.single_target.should be_true
    end
  end

  describe "#set_match" do
    it "should set 'status' and 'match_statement'" do
      @record.set_match(true, "Pub Dates ok")
    end
  end
  
  describe "#match?" do
    it "should return the match status of the record" do
      @record.set_match(true, "Pub Dates ok")
      expect(@record.match?).to eq({:updated => true, :statement=>"Pub Dates ok"})
    end
  end

  describe "#to_xml" do

   it "should return an xml representation" do 
     marc_records = MarcRecords.new
     marc_records.load_data("spec/test_data.xml")
     @record.marc_record = marc_records.list[0]
     @record.expand!

    xml_record = "<doc><field name=\"id\">954921332001</field><field name=\"ua_object_id\">954921332001</field><field name=\"ua_issnPrint\">0000-0019</field><field name=\"ua_catkey\">5903768</field></doc>"

     expect(@record.to_xml).to eq(xml_record)

    end
  end
end
