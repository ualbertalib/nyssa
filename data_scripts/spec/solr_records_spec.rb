require_relative "spec_helper"

RSpec.configure do |c|
  c.include TestData
end

describe SolrRecordSet do

  let(:marcxml){ StringIO.new(single_record) }
  let(:match_records){ StringIO.new(match_data) }
  let(:solr_records){ SolrRecordSet.new(marcxml) }

  context "provided with a marcxml filename" do
    it "reads in the marc data and populates a an array of Record" do
      expect(solr_records.records["0000-0019"]).to be_an_instance_of Record
    end
  end

  context "provided with a matchissn filename" do
    it "populates each record with a match/updated status" do
      solr_records.match(match_records)
      expect(solr_records.records["0000-0019"].updated?).to eq({:updated=>true, :statement=>"Pub Dates ok"})
    end
  end

  context "provided with a BadIssn object" do
    let(:badissn_records){ StringIO.new(bad_issn_data) }
    let(:badissn){ BadIssn.new(badissn_records) }
    it "populates each record with a bad issn status" do
      solr_records.add_bad_issns(badissn)
      expect(solr_records.records["0000-0019"].bad_issn).to be_false
    end
  end

  context "provided with a HoldingsError object" do
    let(:holdingerrors_records){ StringIO.new(holding_error_records) }
    let(:holdingerrors){ HoldingErrors.new(holdingerrors_records) }
    it "populates each record with a holdings error status" do
      solr_records.add_holding_errors(holdingerrors)
      expect(solr_records.records["0000-0019"].holding_error).to be_false   # I realize I'm only testing one side of these conditions
      expect(solr_records.records["0000-0019"].holding_error_statement).to eq ""
    end
  end

  context "provided with SummaryHoldings object" do
    let(:summaryholdings_records){ StringIO.new(summary_holdings_records) }
    let(:summary_holdings){ SummaryHoldings.new(summaryholdings_records) }
    it "populates each record with a summary holdings status" do
      solr_records.add_summary_holdings(summary_holdings)
      expect(solr_records.records["0000-0019"].summary_holdings).to eq "1990-"
    end
  end

  context "once the records are fully populated" do

    let(:badissn_records){ StringIO.new(bad_issn_data) }
    let(:badissn){ BadIssn.new(badissn_records) }
    let(:holdingerrors_records){ StringIO.new(holding_error_records) }
    let(:holdingerrors){ HoldingErrors.new(holdingerrors_records) }
    let(:summaryholdings_records){ StringIO.new(summary_holdings_records) }
    let(:summary_holdings){ SummaryHoldings.new(summaryholdings_records) }
    
    it "should return a full xml representation" do
      
      solr_records.match(match_records)
      solr_records.add_bad_issns(badissn)
      solr_records.add_holding_errors(holdingerrors)
      solr_records.add_summary_holdings(summary_holdings)

      expect(solr_records.to_xml).to eq solr_xml
    end

    it "should produce a solr.xml file" do

      solr_records.match(match_records)
      solr_records.add_bad_issns(badissn)
      solr_records.add_holding_errors(holdingerrors)
      solr_records.add_summary_holdings(summary_holdings)

      File.delete("spec/solr.xml") if File.exist?("spec/solr.xml")
      solr_records.to_solr("spec/solr.xml")
      expect(File.open("spec/solr.xml").read.chomp).to eq solr_records.to_xml
    end
  end
end
