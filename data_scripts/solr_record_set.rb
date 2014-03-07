require_relative "web_services.rb"
require_relative "holding_errors.rb"

class SolrRecordSet

  attr_accessor :set

  def initialize(datafile, targetsfile, matchissn, holderr_file)
    @set = {}
    @targets = {}
    @update_statuses = {}
    datafile.each_line do |line|
      if line.include?("|") then
        sfx_object_id = line.split("|").first.strip
        issn = line.split("|")[1].gsub("<", "").gsub(">", "")
        eissn = line.split("|")[2].gsub("<", "").gsub(">", "")
        link = line.split("|")[3].gsub("<", "").gsub(">", "")
        date_statement = line.split("|")[4].gsub("<", "").gsub(">", "")
        related = line.split("|")[5].gsub("<", "").gsub(">", "")
        free = line.split("|")[6].gsub("<", "").gsub(">", "")
	ws = WebServices.new(sfx_object_id)
        @set[sfx_object_id] = {:issn=>issn, :eissn=>eissn, :link => link, :sfx_dates => date_statement, :related => related, :free => free, :titleID => ws.titleID, :sirsi_dates => ws.date_statement} 
      end
    end
    targetsfile.each_line do |line|
      if line.include?("|") then
        sfx_object_id = line.split("|").first.strip
        title = line.split(": ").first.split("|").last.strip.gsub("<", "").gsub(">", "")
        tgts = line.split(": ").last.strip.gsub("<", "").gsub(">", "").split(", ")
        temp = @set[sfx_object_id].merge({:title => title, :targets => tgts}) unless @set[sfx_object_id].nil?
        @set[sfx_object_id] = temp
      end
    end
    matchissn.each_line do |line|
     titleID = line.split("|").first.strip
     update_status = line.split("|").last.strip
     @update_statuses[titleID] = update_status
    end
    
   

    @holderr = HoldingErrors.new(holderr_file)
    @set.each do |key,record|

      @holdings_error = @holderr.for(record[:titleID]) if @holderr.include?(record[:titleID])
      if record
        record.merge!({:update_status=> @update_statuses[record[:titleID].to_s], :ua_updated => (@update_statuses[record[:titleID].to_s] == "Pub Dates ok"), :ua_holdings_comparison => @holdings_error})
      end
    end
  end
 
  def to_solr(outfile)
    of = File.open(outfile, "w")
    of.puts  "<?xml version=\"1.0\" encoding=\"UTF-8\"?><add>"
    @set.each do |key, value|
      unless key.to_s == '' || value.nil?
        of.puts xml_representation(key, value)
      end
    end
    of.puts "</add>"
    of.close
  end

  private
  
  def xml_representation(sfx_object_id, record)
      
      xml_record = %[<doc><field name ="id">#{sfx_object_id}</field><field name = "ua_object_id">#{sfx_object_id}</field><field name = "ua_title">#{record[:title]}</field><field name = "ua_issnPrint">#{record[:issn]}</field><field name = "ua_issnElectronic">#{record[:eissn]}</field><field name = "ua_freeJournal">#{record[:free]}</field><field name = "ua_catkey">#{record[:titleID]}</field><field name = "ua_singleTarget">#{single_target?(record)}</field><field name = "ua_updated">#{record[:ua_updated]}</field><field name="ua_update_status">#{record[:update_status]}</field><field name = "ua_sirsi_date_statement">#{record[:sirsi_dates]}</field><field name = "ua_sfx_date_statement">#{record[:sfx_dates]}</field><field name = "ua_bad_dates">#{record[:bad_dates]}</field><field name="ua_link_text">#{record[:link]}</field><field name="ua_holdings_comparison">#{record[:ua_holdings_comparison]}</field>]
      xml_record+=display_targets(record)
      xml_record+=facet_targets(record)
      xml_record+="</doc>"
  end
  
  def single_target?(record)
    record[:targets].size==1
  end

  def display_targets(record)
    temp_string=""
    target_number = 0
    record[:targets].each do |t|
      tgt = t.gsub("\"", "").gsub("]", "").gsub("[", "").strip
      temp_string+="<field name=\"ua_display_target_#{target_number}\">#{tgt}</field>"
      target_number+=1
    end
   temp_string
  end

  def facet_targets(record)
    temp_string=""
    record[:targets].each do |t|
      tgt = t.gsub("\"", "").gsub("]", "").gsub("[", "").strip
      temp_string+="<field name=\"ua_target\">#{tgt}</field>"
    end
   temp_string
  end
end
