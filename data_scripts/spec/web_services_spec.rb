require_relative "spec_helper"

describe WebServices do
  let(:sfx_object_id){ "954921332001" }
  let(:web_services){ WebServices.new(sfx_object_id) }

  context "supplied with an object_id" do
    it "should return a titleID if it finds a record" do
      expect(web_services.titleID).to eq "5903768"
    end

    it "should return the Sirsi date statement if it finds a record" do
      expect(web_services.date_statement).to eq "1990-"
    end

    it "should return an error message if it does not find a record" do
      not_in_sirsi = WebServices.new("0000000000000000")
      expect(not_in_sirsi.titleID).to eq "No record found."
    end
  end
end
