require("marc")
require_relative("includes")

puts "Usage: main.rb marcxml matchissn badissn holderr summary outfile" unless ARGV[0]

marcxml_file = ARGV[0]
matchissn = ARGV[1]
badissn = ARGV[2]
holdings_errors = ARGV[3]
summary_holdings = ARGV[4]
solr_xml = ARGV[5]

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
