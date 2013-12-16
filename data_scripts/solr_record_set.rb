class SolrRecordSet

  attr_reader :list, :records

  def initialize(data_file)
    @records = {}
    reader = MARC::XMLReader.new(data_file)
    for record in reader
      r = Record.new(record)
      records[r.issn] = r
    end
  end

  def to_xml
    xml_record = %[<?xml version="1.0" encoding="UTF-8"?><add>]
      @records.each do |key, value|
        xml_record += value.to_xml
      end
    xml_record += %[</add>]
  end

  def to_solr(solr_file)
    File.open(solr_file, "w"){|f|
      f.puts self.to_xml
    }
  end

  def match(match_file)
    match_file.each_line do |line|
      data = line.split("|")
      issn = data[2].chomp
      statement = data[3].chomp
      @records[issn].set_match(updated?(statement), statement) if @records[issn]
    end
  end

  def add_bad_issns(bad_issn_object)
    @records.each do |issn,record|
      record.bad_issn = bad_issn_object==record.titleID
    end
  end

  def add_holding_errors(holding_errors_object)
    @records.each do |issn,record|
      record.holding_error = holding_errors_object.include?(record.titleID)
      record.holding_error_statement = holding_errors_object.for(record.titleID)
    end
  end

  def add_summary_holdings(summary_holdings_object)
    @records.each do |issn,record|
      record.summary_holdings = summary_holdings_object.statement(record.sfx_object_id)
    end
  end

  private

  def load_marc_records(data_file)
    @matched_records = process(MarcRecords.new(data_file))
  end
  
  def updated?(statement)
    statement.include?("Not updated") ? false : true
  end
end
