require_relative "spec_helper"

describe SolrRecordSet do
  context "given a full or incremental sfx2sirsi file" do
    let(:solr_records){ SolrRecordSet.new(File.open("sfx-sirsi-full.txt"), File.open("targets.txt")) }
    it "should read the file and create a set of records" do
      expect(solr_records.set).to be_an_instance_of Hash
    end

    it "should read the records into the hash" do
      expect(solr_records.set.size).to be > 0
    end

    it "should have a hash as the body of each hash, containing the record" do
      expect(solr_records.set.values.first).to be_an_instance_of Hash
    end

    it "should be able to list the targets for a given sfx_object_id" do
      expect(solr_records.set["954921332001"][:targets]).to be_an_instance_of Array
    end
  end
end
