require_relative("spec_helper")

describe HoldingErrors do

  let(:holding_errors){ HoldingErrors.new(StringIO.new(holding_error_records)) }

  context "when provided with a title id" do
    it "returns true if the title is in the list" do
      expect(holding_errors.include?("659588")).to be_true
    end
    it "returns the holdings error statement" do
      true_message = "s0001-4346:    SFX end date too late: SFX-1997 Sirsi-1991:    SFX Holdings: 1967-1997"
      expect(holding_errors.for("659588")).to eq true_message
    end
    it "returns false if the title is not in the list" do
      expect(holding_errors.include?("5555555")).to be_false
    end
    it "returns empty string if the title is not in the list" do
      expect(holding_errors.for("5555555")).to eq ""
    end
  end
end
