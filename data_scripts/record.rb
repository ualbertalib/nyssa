require_relative "web_services"

class Record

  class MarcRecord

    attr_accessor :sfx_object_id, :title, :issnPrint, :issnElectronic, :targets

  end
  
  attr_reader :marc_record, :titleID, :issn, :sfx_object_id

  def initialize 
    @marc_record = MarcRecord.new
  end
 
  def marc_record=(record)
    @marc_record = record
    @sfx_object_id = record.sfx_object_id
    @issn = record.issnPrint
    @titleID = fetch_titleID
  end

  def set_match(status, statement)
    @update_status = status
    @match_statement = statement
  end

  def updated?
    {:updated=> @update_status, :statement => @match_statement}
  end

  def to_xml
    %[<doc><field name=\"id\">#{@sfx_object_id}</field><field name=\"ua_sfx_object_id\">#{@sfx_object_id}</field><field name=\"ua_issnPrint\">#{@issn}</field><field name=\"ua_titleID\">#{@titleID}</field></doc>]
  end

  private 

  def fetch_titleID
    WebServices.new.titleID(@marc_record.sfx_object_id)
  end

  # Doesn't seem to be called anywhere... possibly just for future to_xml
  #def single_target
  #  @marc_record.targets.size==1
  #end
end
