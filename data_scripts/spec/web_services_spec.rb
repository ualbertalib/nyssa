require_relative "spec_helper"

describe WebServices do
  let(:web_services){ WebServices.new }
  let(:object_id){ "954921332001" }
  context "supplied with an object_id" do
    it "should return a titleID if it finds a record" do
      web_services.titleID(object_id).should eq "5903768"
    end

    it "should return the Sirsi date statement if it finds a record" do
      web_services.date_statement(object_id).should eq "1990-"
    end

    it "should return an error message if it does not find a record" do
      web_services.titleID("0000000000000000").should eq "No record found."
    end
  end
end
