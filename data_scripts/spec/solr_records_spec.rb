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
      @solr_records.list.should be_an_instance_of Array
    end
  end

  it "should load marc data and populate the list of records" do
    @solr_records.load_marc_records("spec/test_data.xml")
    @solr_records.list[0].should be_an_instance_of Record
    @solr_records.list[0].marc_record.object_id.should_not be_nil
  end
end
