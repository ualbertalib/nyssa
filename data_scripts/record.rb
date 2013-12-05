require_relative "web_services"

class Record

  class MarcRecord

    attr_accessor :object_id, :title, :issnPrint, :issnElectronic, :targets

  end
  
  attr_reader :marc_record, :catkey, :issn

  def initialize 
    # I think that as long as MarcRecord is defined within Record this should
    # be OK. 
    @marc_record = MarcRecord.new
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

  def single_target
    @marc_record.targets.size==1
  end

  def set_match(status, statement)
    @update_status = status
    @match_statement = statement
  end

  def updated?
    {:updated=> @update_status, :statement => @match_statement}
  end

  def to_xml
    %[<doc><field name=\"id\">#{@object_id}</field><field name=\"ua_object_id\">#{@object_id}</field><field name=\"ua_issnPrint\">#{@issn}</field><field name=\"ua_catkey\">#{@catkey}</field></doc>]
  end

  private 

  def call_web_services
    # Use dependency injection here? 
    # def call_web_services(web_services_object)
    #   web_services.call(@marc_record.object_id)
    # end
    # This makes this method much simpler.
    # And the specification of WebServices.new passes
    # up to the spec or the mainline
    web_services = WebServices.new
    web_services.call_by_object_id(@marc_record.object_id)
    web_services
  end
end
