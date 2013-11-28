require_relative "marc_record"
require_relative "web_services"

class Record < MarcRecord
  
  attr_reader :marc_record, :catkey

  def initialize 
    @catkey = ""
    @pubDateNotes = ""
    @updated = ""
    @bad_dates = ""
    @bad_issn_statement = "" # derive bad_issn, no_issn
    @no_url = ""
    @date_statement = ""
    @holdings_comparison = ""
    @marc_record = MarcRecord.new
  end
 
  def marc_record=(record)
    @marc_record = record
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
end
