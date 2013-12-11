require_relative("spec_helper")

RSpec.configure do |c|
  c.include TestData
end

describe BadIssn do

  let(:bad_issn){ BadIssn.new(StringIO.new(bad_issn_data)) }

# BadIssn takes reads the badissn data, takes in a titleID and returns whether the issn is bad or not.

  context "when provided with a titleID" do
    it "returns if the record's issn is in the list" do
      expect(bad_issn=="6059055").to be_true
    end
    it "returns false if the record's issn is not in the list" do
      expect(bad_issn=="5555555").to be_false
    end
  end

end
