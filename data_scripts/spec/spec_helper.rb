require_relative("../record")
require_relative("../solr_record_set")
require_relative("../web_services")
require_relative("../bad_issn")
require_relative("../holding_errors")
require_relative("../summary_holdings")
require_relative("../sirsi_records.rb")
require_relative("./test_data")

RSpec.configure do |c|
  c.include TestData
end
