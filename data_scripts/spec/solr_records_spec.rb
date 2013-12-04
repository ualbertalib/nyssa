require_relative "spec_helper"

describe SolrRecordSet do

  before :each do
    @solr_records = SolrRecordSet.new
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
      @solr_records.load_marc_records("spec/test_data.xml")
      key, value = @solr_records.list.first
      value.should be_an_instance_of Record
      key.should eq "0000-0019"
    end
  end

  describe "#load_match_data" do
    it "should read from matchissn" do
      @solr_records.load_match_data("spec/test_match_data.txt")
      @solr_records.raw_match_data.should be_an_instance_of Array
      @solr_records.raw_match_data[0].should_not be_nil
    end
  end

  describe "#match!" do
    it "should add match data to records in list" do
      @solr_records.load_marc_records("spec/test_data.xml")
      @solr_records.load_match_data("spec/test_match_data.txt")
      @solr_records.match!
      expect(@solr_records.list["0000-0019"].match?).to eq({:updated=>true, :statement=>"Pub Dates ok"})
    end

    it "should return updated = false if not updated" do
      @solr_records.load_marc_records("spec/test_data.xml")
      @solr_records.load_match_data("spec/test_match_data.txt")
      @solr_records.match!
      expect(@solr_records.list["0001-2610"].match?).to eq({:updated=>false, :statement=>"Not updated - Bad Pub dates - NO Related Records "})
    end
  end
end
