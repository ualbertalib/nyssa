require_relative "web_services"

class Record

  class MarcRecord

    def initialize(record)
      @record = record
    end

    def sfx_object_id
      @record['090']['a'] || ""
    end

    def electronicISSN
      @record['776']['a'] || ""
    end

    def issnPrint
      @record['022']['a'] || ""
    end

    def title
      @record['245']['a'].gsub(">","").gsub("<", "") || ""
    end

    def language
      @record['008'].to_s[-5..-3] || ""
    end

    def targets
      tgts = @record.find_all{|t| ('866') === t.tag}
      target_list = []
      tgts.each{|t| target_list << t['x'].to_s }
      target_list.join(", ")
    end

  end
  
  attr_reader :marc_record 

  def initialize(record)
    record = MARC::XMLReader.new(StringIO.new(record))
    @marc_record = MarcRecord.new(record.first)
    populate!
  end
 
  def populate!
    @sfx_object_id = @marc_record.sfx_object_id
    @issn = @marc_record.issnPrint
    @titleID = fetch_titleID
    @title = @marc_record.title
    @eissn = @marc_record.electronicISSN
    @language = @marc_record.language
    @no_issn = ""
    @bad_dates = ""
    @bad_issn = ""
    @no_url = ""
    @holdings_comparison = ""
  end

  def set_match(status, statement)
    @update_status = status
    @match_statement = statement
  end

  def updated?
    {:updated=> @update_status, :statement => @match_statement}
  end

  def to_xml
   xml_record =  %[<doc><field name=\"id\">#{@sfx_object_id}</field><field name=\"ua_object_id\">#{@sfx_object_id}</field><field name=\"ua_title\">#{@title}</field><field name=\"ua_issnPrint\">#{@issn}</field><field name=\"ua_issnElectronic\">#{@eissn}</field><field name=\"ua_freeJournal\">free</field><field name=\"ua_language\">#{@language}</field><field name=\"ua_catkey\">#{@titleID}</field><field name=\"ua_singleTarget\">#{@single_target}</field><field name=\"ua_noISSN\">#{@no_issn}</field><field name=\"ua_updated\">#{@update_status}</field><field name=\"ua_bad_dates\">#{@bad_dates}</field><field name=\"ua_bad_issn\">false</field><field name=\"ua_bad_issn_statement\">#{@bad_issn}</field><field name=\"ua_no_url\">#{@no_url}</field><field name=\"ua_holdings_comparison">#{@holdings_comparison}</field><field name=\"ua_dateStatement\">#{@match_statement}</field></doc>]
  
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
    ts=@marc_record.targets.split(",")
    ts.each do |t|
      temp_string+="<field name=\"ua_target\">#{t.strip}</field>"
    end
   temp_string
  end
end
