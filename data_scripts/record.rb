require_relative "web_services"
require_relative "marc_record"

class Record

  attr_reader :marc_record, :issn

  def initialize(record, bad_issn="", bad_dates="", summary_holdings="")
    @marc_record = MarcRecord.new(record)
    @bad_issn = bad_issn
    @bad_dates = bad_dates
    @summary_holdings = summary_holdings
    populate!
  end
 
  def populate!
    @sfx_object_id = @marc_record.sfx_object_id
    @issn = @marc_record.issnPrint
    @titleID = fetch_titleID
    @title = @marc_record.title
    @eissn = @marc_record.electronicISSN
    @language = @marc_record.language
    @no_issn = "false"
    @no_url = ""
  end

  def set_match(status, statement)
    @update_status = status 
    @match_statement = statement 
  end

  def updated?
    {:updated=> @update_status, :statement => @match_statement}
  end

  def to_xml
   xml_record =  %[<doc><field name=\"id\">#{@sfx_object_id}</field><field name=\"ua_object_id\">#{@sfx_object_id}</field><field name=\"ua_title\">#{@title}</field><field name=\"ua_issnPrint\">#{@issn}</field><field name=\"ua_issnElectronic\">#{@eissn}</field><field name=\"ua_freeJournal\">free</field><field name=\"ua_language\">#{@language}</field><field name=\"ua_catkey\">#{@titleID}</field><field name=\"ua_singleTarget\">#{single_target}</field><field name=\"ua_noISSN\">#{@no_issn}</field><field name=\"ua_updated\">#{@update_status}</field><field name=\"ua_bad_dates\">#{has_bad_dates}</field><field name=\"ua_bad_issn\">#{bad_issn}</field><field name=\"ua_no_url\">#{@no_url}</field><field name=\"ua_holdings_comparison">#{bad_date_statement}</field><field name=\"ua_dateStatement\">#{@match_statement}</field><field name=\"ua_summary_holdings">#{summary_holdings_statement}</field>]
  
  xml_record+=targets
  xml_record+="</doc>"
  #xml_record.gsub("<<", "").gsub(">>", "")
  end

  private 

  def fetch_titleID
    WebServices.new.titleID(@marc_record.sfx_object_id)
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

  def bad_issn
    @bad_issn==@titleID || "false"
  end

  def has_bad_dates
    @bad_dates.include?(@titleID) || "false"
  end

  def bad_date_statement
    if @bad_dates != ""
      @bad_dates.for(@titleID)
    else
      ""
    end
  end

  def summary_holdings_statement
    if @summary_holdings != ""
      @summary_holdings.statement(@sfx_object_id)
    else
      ""
    end
  end
end
