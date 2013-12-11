require_relative "spec_helper"

describe SolrRecordSet do

  let(:marcxml){ StringIO.new(single_record) }
  let(:match_records){ StringIO.new(match_data) }
  let(:solr_records){ SolrRecordSet.new(marcxml) }
  let(:badissn_records){ StringIO.new(bad_issn_data) }
  let(:badissn){ BadIssn.new(badissn_records) }
  let(:holdingerrors_records){ StringIO.new(holding_error_records) }
  let(:holdingerrors){ HoldingErrors.new(holdingerrors_records) }
  let(:summaryholdings_records){ StringIO.new(summary_holdings_records) }
  let(:summary_holdings){ SummaryHoldings.new(summaryholdings_records) }

  context "provided with a marcxml filename" do
    it "reads in the marc data and populates a an array of Record" do
      expect(solr_records.records["0000-0019"]).to be_an_instance_of Record
    end
  end

  context "provided with a matchissn filename" do
    before :each do solr_records.match(match_records) end

    it "populates each record with a match/updated status" do
      expect(solr_records.records["0000-0019"].updated?).to eq({:updated=>true, :statement=>"Pub Dates ok"})
    end

    context "provided with a BadIssn object" do
    before :each do solr_records.add_bad_issns(badissn) end
      it "populates each record with a bad issn status" do
        expect(solr_records.records["0000-0019"].bad_issn).to be_false
      end

      context "provided with a HoldingsError object" do
        before :each do solr_records.add_holding_errors(holdingerrors) end
        it "populates each record with a holdings error status" do
          expect(solr_records.records["0000-0019"].holding_error).to be_false   
          expect(solr_records.records["0000-0019"].holding_error_statement).to eq ""
        end
 
        context "provided with SummaryHoldings object" do
	  before :each do solr_records.add_summary_holdings(summary_holdings) end
          it "populates each record with a summary holdings status" do
            expect(solr_records.records["0000-0019"].summary_holdings).to eq "1990-"
          end

          context "once the records are fully populated" do

            it "should return a full xml representation" do
              expect(solr_records.to_xml).to eq solr_xml
            end

            it "should produce a solr.xml file" do
              File.delete("spec/solr.xml") if File.exist?("spec/solr.xml")
              solr_records.to_solr("spec/solr.xml")
              expect(File.open("spec/solr.xml").read.chomp).to eq solr_records.to_xml
            end
	  end
	end
      end
    end
  end
end
