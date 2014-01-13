require_relative "spec_helper"

describe SirsiRecords do

  let(:not_in_sfx){ StringIO.new(not_in_sfx_records) }
  let(:sirsi_records){ SirsiRecords.new(not_in_sfx) }

  context "provided with a notSFX.txt file" do
    it "produces a sirsi_only.xml file" do
      File.delete("spec/sirsi_only.xml") if File.exist?("spec/sirsi_only.xml")
      sirsi_records.to_solr("spec/sirsi_only.xml")
      expect(File.open("spec/sirsi_only.xml").read.chomp).to eq sirsi_records.to_xml
    end
  end
end
