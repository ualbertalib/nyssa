require "cgi"
require_relative "web_services"
require_relative "marc_record"

class Record

  attr_reader :marc_record, :issn, :sfx_object_id, :eissn, :open_url
  attr_accessor :bad_issn, :holding_error, :holding_error_statement, :summary_holdings, :title, :targets

  def initialize(record)
    @marc_record = record
    @targets = []
    populate!
  end
 
  def populate!
    @sfx_object_id = @marc_record[:sfx_object_id]
    puts @sfx_object_id
    @issn = @marc_record[:issn]
    @title = ""
    @eissn = @marc_record[:eissn] || ""
    @open_url = @marc_record[:open_url]
    @update_status = "Not in matchissn"
    @match_statement = "Not in matchissn"
    @summary_holdings = @marc_record[:summary_holdings]
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
   xml_record =  %[<doc><field name=\"id\">#{@sfx_object_id}</field><field name=\"ua_object_id\">#{@sfx_object_id}</field><field name=\"ua_title\">#{@title}</field><field name=\"ua_issnPrint\">#{@issn}</field><field name=\"ua_issnElectronic\">#{@eissn}</field><field name=\"ua_freeJournal\">free</field><field name=\"ua_catkey\">#{titleID}</field><field name=\"ua_singleTarget\">#{single_target}</field><field name=\"ua_noISSN\">#{@no_issn}</field><field name=\"ua_updated\">#{@update_status}</field><field name=\"ua_bad_dates\">#{@holding_error}</field><field name=\"ua_bad_issn\">#{@bad_issn}</field><field name=\"ua_no_url\">#{@no_url}</field><field name=\"ua_holdings_comparison">#{@holding_error_statement}</field><field name=\"ua_date_statement\">#{@match_statement}</field><field name=\"ua_summary_holdings\">#{@summary_holdings}</field><field name=\"ua_sirsi_coverage\">#{fetch_sirsi_coverage}</field>]
  
  xml_record+=facet_targets
  xml_record+=display_targets
  xml_record+=%[<field name="ua_last_updated">#{DateTime.now}</field>]
  xml_record+="</doc>"
  #xml_record.gsub("<<", "").gsub(">>", "")
  #CGI::escapeHTML xml_record
  end

  def titleID
    @web_services.titleID
  end

  private 

  def fetch_web_services
    @web_services = WebServices.new(@sfx_object_id)
  end

  def fetch_sirsi_coverage
    @web_services.date_statement
  end

  def single_target
    @targets.size==1
  end

  def display_targets
    temp_string=""
    target_number = 0
    @targets.each do |t|
      tgt = t.gsub("\"", "").gsub("]", "").gsub("[", "").strip
      temp_string+="<field name=\"ua_display_target_#{target_number}\">#{tgt}</field>"
      target_number+=1
    end
   temp_string
  end

  def facet_targets
    temp_string=""
    @targets.each do |t|
      tgt = t.gsub("\"", "").gsub("]", "").gsub("[", "").strip
      temp_string+="<field name=\"ua_target\">#{tgt}</field>"
    end
   temp_string
  end
end
