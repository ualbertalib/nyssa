require_relative "spec_helper"

describe SummaryHoldings do

  before :each do
    @summary_holdings = SummaryHoldings.new(StringIO.new(summary_holdings_records))
  end

  describe "#statement" do
    it "should produce a correct date statement" do
      @summary_holdings.statement("954921332001").should == "1990-"
      @summary_holdings.statement("954921332003").should == "1958-"
      @summary_holdings.statement("954921332004").should == "1987-"
      @summary_holdings.statement("954921333005").should == "1965-"
      @summary_holdings.statement("954921333007").should == "1963-"
      @summary_holdings.statement("954921333008").should == "1994-2010"
      @summary_holdings.statement("954921333009").should == "1996-"
      @summary_holdings.statement("954921333010").should == "2002-2010"
      @summary_holdings.statement("954921333013").should == "1970-"
      @summary_holdings.statement("954921333014").should == "1926-"
      @summary_holdings.statement("954921333015").should == "1992-2004"
      @summary_holdings.statement("954921333016").should == "1956-"
      @summary_holdings.statement("954921333017").should == "1969-"
    end
  end
end
