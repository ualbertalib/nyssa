require "nokogiri"
require "open-uri"

class WebServices

  def call_by_object_id(object_id)
    endpoint="http://ws.library.ualberta.ca/symws3/rest/standard/searchCatalog?clientID=Primo&term1="
    search_url = "#{endpoint}#{object_id}"
    @xml_response = open(search_url).read
    @doc = Nokogiri::XML(open(search_url).read).remove_namespaces!
    @hits = @doc.at_xpath("//totalHits").text   
  end

  def record
    @xml_response
  end

  def titleID 
    if @hits.to_i == 0 then
      return "00000"
    else
      return @doc.at_xpath("//titleID").text
    end
  end

  def date_statement
    statement = ""
    if @hits.to_i == 0 then
      statement = "Record not found in Sirsi"
    else 
      endpoint="http://ws.library.ualberta.ca/symws3/rest/standard/lookupTitleInfo?clientID=Primo&marcEntryFilter=ALL&titleID="
      search_url = "#{endpoint}#{titleID}"
      doc = Nokogiri::XML(open(search_url).read).remove_namespaces!
      doc.xpath("//MarcEntryInfo").each do |element|
        element_value = element.xpath("text").text
        if(element_value.include? "University of Alberta Access") then
          statement = element_value[element_value.index(':')+2..-1]
        end
      end
    end
    statement
  end
end
