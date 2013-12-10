require_relative "spec_helper"

RSpec.configure do |c|
  c.include TestData
end

describe Record do
 context "given a marc record" do
  let(:record){ Record.new(MARC::XMLReader.new(StringIO.new(single_record)).first, 
                                   BadIssn.new(StringIO.new(bad_issn_records)), 
				   HoldingErrors.new(StringIO.new(holding_error_records))) }

  it "returns an xml representation" do
      expect(record.to_xml.chomp).to eq unmatched_solr_record.chomp
    end
  end

end
