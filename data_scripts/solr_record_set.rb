require_relative("marc_records")

class SolrRecordSet

  attr_reader :list

  def initialize
    @list = []
  end

  def load_marc_records(data_file)
    marc_records = MarcRecords.new
    marc_records.load_data(data_file)
    marc_records.list.each do |record|
      r = Record.new
      r.marc_record = record
      @list << r
    end
  end

  def add_supplementary_data
    @list.each do |record|
      record.expand!
    end
  end
end
