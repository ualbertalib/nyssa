require_relative "spec_helper"

describe SolrRecordSet do

  before(:all) do
    @solr_records = SolrRecordSet.new
    @solr_records.load_marc_records("spec/test_data.xml")
    @solr_records.load_match_data("spec/test_match_data.txt") 
    @solr_records.match!
  end

  describe "#new" do
    it "should be an instance of SolrRecordSet" do
      @solr_records.should be_an_instance_of SolrRecordSet
    end
  end

  describe "#list" do
    it "should contain a list of records" do
      @solr_records.list.should be_an_instance_of Hash
    end
  end

  
  describe "#load_marc_records" do
    it "should load marc data and populate the list of records" do
      key, value = @solr_records.list.first
      value.should be_an_instance_of Record
      key.should eq "0000-0019"
    end
  end

  describe "#load_match_data" do
    it "should read from matchissn" do
      @solr_records.raw_match_data.should be_an_instance_of Array
      @solr_records.raw_match_data[0].should_not be_nil
    end
  end

  describe "#match!" do
    it "should add match data to records in list" do
      expect(@solr_records.list["0000-0019"].updated?).to eq({:updated=>true, :statement=>"Pub Dates ok"})
    end

    it "should return updated = false if not updated" do
      expect(@solr_records.list["0001-2610"].updated?).to eq({:updated=>false, :statement=>"Not updated - Bad Pub dates - NO Related Records "})
    end
  end

  describe "#to_xml" do
    it "should return a solr XML representation of the list" do
      xml_representation = File.open("spec/test_solr_data.xml").read.strip
      expect(@solr_records.to_xml).to eq(xml_representation)
    end
  end

  describe "#to_solr" do
    before(:each) do 
      FileUtils.rm("spec/solr.xml") if File.exists?("spec/solr.xml") 
      @solr_records.to_solr("spec/solr.xml")
    end

    it "should write the solr xml records to a given file" do
      expect(File.exist?("spec/solr.xml")).to be_true
    end

    it "should contain the same content as to_xml" do
      xml_representation = File.open("spec/solr.xml").read.strip
      expect(@solr_records.to_xml).to eq(xml_representation)
    end
  end
end

