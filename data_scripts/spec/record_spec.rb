require_relative "spec_helper"

describe Record do

  let(:record){ Record.new }
  let(:marc_records){ MarcRecords.new }


  before :each do
    marc_records.load_data("spec/test_data.xml")
  end

  describe "#new" do
    it "should include a MarcRecord object" do
      record.marc_record.should be_an_instance_of Record::MarcRecord
    end
  end

  describe "#expand!" do
    it "should populate the catkey from the marc_record" do
      record.marc_record=marc_records.list[0]
      record.expand!
      record.catkey.should == "5903768" 
    end
  end

  describe "#single_target" do
    it "should return false if a record has more than one target" do
      record.marc_record=marc_records.list[0]
      record.single_target.should be_false
    end
    it "should return true if a record has only one target" do
      record.marc_record=marc_records.list.last
      record.single_target.should be_true
    end
  end

  describe "#match?" do
    it "should return the match status of the record" do
      record.set_match(true, "Pub Dates ok")
      expect(record.match?).to eq({:updated => true, :statement=>"Pub Dates ok"})
    end
  end

  describe "#to_xml" do
   it "should return an xml representation" do 
     record.marc_record = marc_records.list[0]
     record.expand!
     xml_record = "<doc><field name=\"id\">954921332001</field><field name=\"ua_object_id\">954921332001</field><field name=\"ua_issnPrint\">0000-0019</field><field name=\"ua_catkey\">5903768</field></doc>"
     expect(record.to_xml).to eq(xml_record)
    end
  end
end
