require_relative "web_services"
require_relative "marc_record"

class Record

  attr_reader :marc_record, :issn, :titleID, :sfx_object_id
  attr_accessor :bad_issn, :holding_error, :holding_error_statement, :summary_holdings

  def initialize(record)
    @marc_record = MarcRecord.new(record)
    populate!
  end
 
  def populate!
    @sfx_object_id = @marc_record.sfx_object_id
    @issn = @marc_record.issnPrint
    @title = @marc_record.title
    @eissn = @marc_record.electronicISSN
    @language = @marc_record.language
    @no_issn = "false"
    @no_url = ""
    fetch_web_services
  end

  def set_match(status, statement)
    @update_status = status 
    @match_statement = statement 
  end

  def updated?
    {:updated=> @update_status, :statement => @match_statement}
  end

  def to_xml
   xml_record =  %[<doc><field name=\"id\">#{@sfx_object_id}</field><field name=\"ua_object_id\">#{@sfx_object_id}</field><field name=\"ua_title\">#{@title}</field><field name=\"ua_issnPrint\">#{@issn}</field><field name=\"ua_issnElectronic\">#{@eissn}</field><field name=\"ua_freeJournal\">free</field><field name=\"ua_language\">#{@language}</field><field name=\"ua_catkey\">#{fetch_titleID}</field><field name=\"ua_singleTarget\">#{single_target}</field><field name=\"ua_noISSN\">#{@no_issn}</field><field name=\"ua_updated\">#{@update_status}</field><field name=\"ua_bad_dates\">#{@holding_error}</field><field name=\"ua_bad_issn\">#{@bad_issn}</field><field name=\"ua_no_url\">#{@no_url}</field><field name=\"ua_holdings_comparison">#{@holding_error_statement}</field><field name=\"ua_date_statement\">#{@match_statement}</field><field name=\"ua_summary_holdings\">#{@summary_holdings}</field><field name=\"ua_sirsi_coverage\">#{fetch_sirsi_coverage}</field>]
  
  xml_record+=targets
  xml_record+="</doc>"
  #xml_record.gsub("<<", "").gsub(">>", "")
  end

  private 

  def fetch_web_services
    @web_services = WebServices.new(@sfx_object_id)
  end

  def fetch_titleID
    @web_services.titleID
  end

  def fetch_sirsi_coverage
    @web_services.date_statement
  end

  def single_target
    @marc_record.targets.size==1
  end

  def targets
    temp_string=""
    @marc_record.targets.each do |t|
      temp_string+="<field name=\"ua_target\">#{t.strip}</field>"
    end
   temp_string
  end
end
