require_relative "spec_helper"

RSpec.configure do |c|
  c.include TestData
end

describe SolrRecordSet do

  let(:solr_records){ SolrRecordSet.new(StringIO.new(single_record), "spec/data/test_match_data.txt") }

  context "given an sfx data file" do
    it "loads the specified data file into an hash of records" do
      expect(solr_records.list).to_not be_empty
    end
  end

  context "given a populated hash" do
   it "should have a list of Records" do
     expect(solr_records.list["0000-0019"]).to be_an_instance_of Record
   end
  end

  context "once the hash is populated" do
    it "should contain complete xml representations of records" do
      expect(solr_records.list["0000-0019"].to_xml).to eq matched_solr_record    
    end
  end

  context "when asked for a solr.xml file" do
    it "produces the right solr.xml records" do
      expect(solr_records.to_xml).to eq solr_xml
    end

    it "creates a solr.xml file" do
      File.delete("spec/data/test_solr.xml") if File.exist?("spec/data/test_solr.xml")
      solr_records.to_solr("spec/data/test_solr.xml")
      expect(File.open("spec/data/test_solr.xml").read.chomp).to eq solr_records.to_xml
    end
  end
end
