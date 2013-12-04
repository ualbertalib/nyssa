require_relative("marc_records")

class SolrRecordSet

  attr_reader :list, :raw_match_data

  def initialize
    @list = {}
    @raw_match_data = []
  end

  def load_marc_records(data_file)
    marc_records = MarcRecords.new
    marc_records.load_data(data_file)
    marc_records.list.each do |record|
      r = Record.new
      r.marc_record = record
      @list[r.issn] = r
    end
  end

  def add_supplementary_data
    @list.each do |record|
      record.expand!
    end
  end

  def load_match_data(data_file)
    File.open(data_file).each_line do |line|
      @raw_match_data << line
    end
  end

  def match!
    @raw_match_data.each do |match|
      data = match.split("|")
      issn = data[2].chomp
      statement = data[3].chomp
      @list[issn].set_match(true, statement) if statement == "Pub Dates ok"
      @list[issn].set_match(false, statement) if statement.include? "Not updated"
    end
  end
end
