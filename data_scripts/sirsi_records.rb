class SirsiRecords

  def initialize(data_file)
    @records = {}
    data_file.each_line do |line|
      split_line = line.chomp.split("|")
      issn = split_line.first
      titleID = split_line[2]
      link_text = split_line[3]
      @records[split_line.first] = {:issn => issn, :titleID => titleID, :link_text => link_text}
    end
  end

  def to_xml
    xml_records = "<?xml version=\"1.0\" encoding=\"UTF-8\"?><add>"
    @records.each do |issn,record|
      xml_records += "<doc><field name=\"id\">#{record[:titleID]}</field><field name=\"ua_issnPrint\">#{record[:issn]}</field><field name=\"ua_catkey\">#{record[:titleID]}</field><field name=\"ua_link_text\">#{record[:link_text]}</field><field name=\"ua_inSirsi\">true</field>"
    end
    xml_records+="</add>"
  end

  def to_solr(output_file)
    File.open(output_file, "w"){|f|
      f.puts self.to_xml
    }
  end
end

