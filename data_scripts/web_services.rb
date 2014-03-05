require "nokogiri"
require "open-uri"

class WebServices

  attr_reader :titleID

  def initialize(sfx_object_id)
    @sfx_object_id = sfx_object_id
    @titleID = fetch_titleID
  end

  def fetch_titleID
    doc = call(@sfx_object_id)
    if hits(doc).to_i == 0 then
      return "No record found."
    else
      return doc.at_xpath("//titleID").text
    end
  end

  def date_statement
    @statement = ""
    doc = call(@sfx_object_id)
    if @titleID == "No record found." then
      @statement = "Record not found in Sirsi"
    else 
      endpoint="http://ws.library.ualberta.ca/symws3/rest/standard/lookupTitleInfo?clientID=Primo&marcEntryFilter=ALL&titleID="
      search_url = "#{endpoint}#{@titleID}"
      doc = Nokogiri::XML(open(search_url).read).remove_namespaces!
      doc.xpath("//MarcEntryInfo").each do |element|
        element_value = element.xpath("text").text
        if((element_value.include?("University of Alberta Access")) && (element_value.include?(":"))) then
           @statement = element_value[element_value.index(':')+2..-1] 
        end
      end
    end
    @statement
  end

#  def electronic_issn
#    @eissn = ""
#    doc = call(@sfx_object_id)
#    if @titleID == "No record found." then
#      @eissn = "Record not found in Sirsi"
#    else 
#      endpoint="http://ws.library.ualberta.ca/symws3/rest/standard/lookupTitleInfo?clientID=Primo&marcEntryFilter=ALL&titleID="
#      search_url = "#{endpoint}#{@titleID}"
#      doc = Nokogiri::XML(open(search_url).read).remove_namespaces!
#      doc.xpath("//MarcEntryInfo").each do |element|
#        field_number = element.xpath("entryID").text
#        if field_number=="776" then
#           @eissn = element.xpath("text").text
#	end
#      end
#    end
#    @eissn
#  end

  private

  def hits(document)
    document.at_xpath("//totalHits").text     
  end

  def call(object_id)
    endpoint="http://ws.library.ualberta.ca/symws3/rest/standard/searchCatalog?clientID=Primo&term1="
    search_url = "#{endpoint}#{object_id}"
    Nokogiri::XML(open(search_url).read).remove_namespaces!
  end

end
