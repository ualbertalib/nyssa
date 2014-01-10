require("marc")
require_relative("includes")

puts "Usage: main.rb sfx/sirsi marcxml matchissn badissn holderr summary outfile"; exit unless ARGV[0]

def process_sfx_records(marcxml_file, matchissn, badissn, holdings_errors, summary_holdings, solr_xml)
puts "#new"
solr_record_set = SolrRecordSet.new(marcxml_file)
puts "#matchissn: #{matchissn}"
solr_record_set.match(File.open(matchissn).read)
puts "#badissn"
solr_record_set.add_bad_issns(badissn)
puts "#holdings_errors"
solr_record_set.add_holding_errors(HoldingErrors.new(File.open(holdings_errors).read))
puts "#summary_holdings"
solr_record_set.add_summary_holdings(SummaryHoldings.new(File.open(summary_holdings)))
puts "#to_solr"
solr_record_set.to_solr(solr_xml)
end

def process_sirsi_records(sirsi_file, sirsi_outfile)
sirsi_records = SirsiRecords.new(File.open(sirsi_file).read)
sirsi_records.to_solr(sirsi_outfile)
end

if ARGV[0] == "sfx"
marcxml_file = ARGV[1]
matchissn = ARGV[2]
badissn = ARGV[3]
holdings_errors = ARGV[4]
summary_holdings = ARGV[5]
solr_xml = ARGV[6]
puts "processing sfx records"
process_sfx_records(marcxml_file, matchissn, badissn, holdings_errors, summary_holdings, solr_xml)
else
sirsi_file = ARGV[1]
sirsi_outfile = ARGV[2]
process_sirsi_records(sirsi_file, sirsi_outfile)
end
