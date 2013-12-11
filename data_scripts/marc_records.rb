require("marc")
require_relative("record")

class MarcRecords

  attr_reader :list

  def initialize(data_file)
    @list = []
    load_data(data_file)
  end
  
  private

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
