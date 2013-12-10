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
    Record.new(record)
  end
end
