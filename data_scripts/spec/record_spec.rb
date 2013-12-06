require_relative "spec_helper"

describe Record do
  let(:record){ Record.new }
  let(:marc_record){ double() }

  before :each do
    marc_record.stub(:issnPrint){ "0000-0019" }
    marc_record.stub(:sfx_object_id){ "954921332001" }
  end

  before(:each){ record.marc_record = marc_record }
 
 context "given a marc record" do
    
    it "stores the marc record" do
      expect(record.marc_record).to eq marc_record
    end
    
    # Not sure these expectations are required, since they're covered
    # by the to_xml test further on...
    
    it "populates the issn" do 
      expect(record.issn).to eq "0000-0019" 
    end

    it "populates the object id" do
      expect(record.sfx_object_id).to eq "954921332001"
    end

    it "populates the titleID" do
      expect(record.titleID).to eq "5903768"
    end

  end

  context "given a an update statement" do
   it "stores the update statement" do
     updated = true
     statement = "Pub Dates ok"
     record.set_match(updated, statement)
     expect(record.updated?).to eq({:updated=>true, :statement=>"Pub Dates ok"})
   end
  end

  context "when asked for an xml representation" do
    let(:xml_record){  %[<doc><field name=\"id\">954921332001</field><field name=\"ua_sfx_object_id\">954921332001</field><field name=\"ua_issnPrint\">0000-0019</field><field name=\"ua_titleID\">5903768</field></doc>] }
   
    it "returns the correct representation" do
      expect(record.to_xml).to eq xml_record
    end
  end
end
