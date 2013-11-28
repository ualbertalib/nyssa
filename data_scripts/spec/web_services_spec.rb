require "spec_helper"

describe WebServices do

  before :each do
    @web_services = WebServices.new
    @web_services.call_by_object_id("954921341152")
  end

  describe "#call_by_object_id" do
    it "should respond to call_by_object_id" do
      @web_services.should respond_to(:call_by_object_id)
    end

    it "should return an xml record" do
      xml_record = File.open("spec/test_brief_sirsi_record.xml").read.gsub(/[0-9][0-9]-[0-9]+/, "")
      @web_services.record.gsub(/[0-9][0-9]-[0-9]+/, "").should == xml_record
    end
  end

  describe "#titleID" do
    it "should return the titleID of the record" do
      @web_services.titleID.should == "414895"
    end
  end

  describe "#date_statement" do
    it "should return the date coverage statement" do
      confirmed_record = WebServices.new
      confirmed_record.call_by_object_id("954921332001")
      confirmed_record.date_statement == "1990-"
      confirmed_record.call_by_object_id("110985822451368")
      confirmed_record.date_statement == "1921-1925"
    end

    it "should return an xml message" do
      failing_record = WebServices.new
      failing_record.call_by_object_id("954921411350")
      failing_record.date_statement.should == "Record not found in Sirsi"
    end
  end

end
