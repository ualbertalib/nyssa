require_relative "spec_helper"

describe Record do
 context "given a marc record" do
  let(:record){ Record.new(MARC::XMLReader.new(StringIO.new(single_record)).first) }

  it "returns an xml representation" do
      expect(record.to_xml.chomp).to eq unmatched_solr_record.chomp
    end
  end

end
