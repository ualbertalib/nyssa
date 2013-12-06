require("marc")
require_relative("record")

class MarcRecords

  attr_reader :list

  def initialize(data_file)
    @list = []
    load_data(data_file)
  end
  
  private

  def parse_targets(record)
    targets = record.find_all{|t| ('866') === t.tag}
    target_list = []
    targets.each{|t| target_list << t['x'].to_s }
    target_list
  end

  def load_data(data_file)
    reader = MARC::XMLReader.new(data_file)
    for record in reader
      @list << populate!(record)
    end
  end

  def populate!(record)
      marc_record = new_marc_record
      marc_record.sfx_object_id = sfx_object_id(record)  
      marc_record.title = title(record) 
      marc_record.issnPrint = issn(record)      
      marc_record.issnElectronic = eissn(record)
      marc_record.targets = parse_targets(record)
      marc_record
  end

  # isolate dependencies on marc
  
  def new_marc_record
    Record::MarcRecord.new
  end
  def sfx_object_id(record)
    record['090']['a'] if record['090'] 
  end
  
  def title(record)
    record['245']['a'].gsub(">","").gsub("<", "") if record['245'] 
  end

  def issn(record)
    record['022']['a'] if record['022']
  end
  
  def eissn(record)
    record['776']['x'] if record['776']
  end

end
