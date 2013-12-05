require_relative "spec_helper"

describe MarcRecord do
  describe "#new" do
    before { @marc_record = MarcRecord.new }
    it "should return a MarcRecord object" do
      @marc_record.should be_an_instance_of MarcRecord
    end
 
    it "should have the following fields" do
      variables = @marc_record.instance_variables
      variables.should include(:@object_id)
      variables.should include(:@title)
      variables.should include(:@issnPrint)
      variables.should include(:@issnElectronic)
    end

    it "should have a list of targets" do
      @marc_record.targets.should be_an_instance_of Array
    end
  end
end
