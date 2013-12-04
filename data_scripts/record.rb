require_relative "marc_record"
require_relative "web_services"

class Record < MarcRecord
  
  attr_reader :marc_record, :catkey, :issn

  def initialize 
    @catkey = ""
    @pubDateNotes = ""
    @updated = ""
    @bad_dates = ""
    @bad_issn_statement = "" # derive bad_issn, no_issn
    @no_url = ""
    @date_statement = ""
    @match_statement = ""
    @marc_record = MarcRecord.new
    @object_id = ""
    @issn = ""
  end
 
  def marc_record=(record)
    @marc_record = record
    @object_id = record.object_id
    @issn = record.issnPrint
  end

  def expand!
    sirsi_record = call_web_services
    @catkey = sirsi_record.titleID
  end

  def call_web_services
    web_services = WebServices.new
    web_services.call_by_object_id(@marc_record.object_id)
    web_services
  end

  def single_target
    @marc_record.targets.size==1
  end

  def set_match(status, statement)
    @update_status = status
    @match_statement = statement
  end

  def match?
    {:updated=> @update_status, :statement => @match_statement}
  end
end
