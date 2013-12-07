require_relative "spec_helper"

describe SolrRecordSet do

  let(:solr_records){ SolrRecordSet.new("spec/data/test_data.xml", "spec/data/test_match_data.txt") }

  context "given an sfx data file" do
    it "loads the specified data file into an hash of records" do
      expect(solr_records.list).to_not be_empty
    end
  end

  context "given a populated hash" do
   it "should have an list of Records" do
     expect(solr_records.list.first).to be_an_instance_of Record::MarcRecord
   end
  end

  context "once the hash is populated" do

    it "should contain complete Records" do
      expect(solr_records.list.first.issnElectronic).to eq("2150-4008")
      expect(solr_records.list.first.issnPrint).to eq("0000-0019")
      expect(solr_records.list.first.sfx_object_id).to eq("954921332001")
      expect(solr_records.list.first.targets).to eq(["Academic Search Complete:Full Text", "Business Source Complete:Full Text","Canadian Reference Centre:Full Text", "EBSCOhost Library & Information Science Source:Full Text", "EBSCOhost OmniFile Full Text Select:Full Text", "Education Research Complete:Full Text", "Factiva:Full Text", "Free E- Journals:Full Text", "Gale Cengage Contemporary Women's Issues:Full Text", "Gale Cengage CPI.Q:Full Text","Gale Cengage Literature Resource Center:Full Text", "Literary Reference Center:Full Text","MasterFILE Premier:Full Text","MAS Ultra - School Edition:Full Text","ProQuest ABI/INFORM Global New Platform:Full Text"])
      expect(solr_records.list.first.title).to eq("Publishers weekly")
    end
  end

  context "it produces a solr.xml file" do

  end
end
