require("marc")

class MarcRecords

  attr_reader :list

  def initialize
    @list = []
  end
  
  def load_data(data_file)
    reader = MARC::XMLReader.new(data_file)
    for record in reader
      marc_record = MarcRecord.new
      marc_record.object_id = record['090']['a'] if record['090']   
      marc_record.title = record['245']['a'].gsub(">","").gsub("<", "") if record['245'] 
      marc_record.issnPrint = record['022']['a'] if record['022']
      marc_record.issnElectronic = record['776']['x'] if record['776']
      marc_record.targets = parse_targets(record)
      @list << marc_record
    end
  end

  def parse_targets(record)
    targets = record.find_all{|t| ('866') === t.tag}
    target_list = []
    targets.each{|t| target_list << t['x'].to_s }
    target_list
  end
end
