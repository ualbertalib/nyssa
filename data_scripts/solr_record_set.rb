class SolrRecordSet

  attr_accessor :set

  def initialize(datafile, targetsfile)
    @set = {}
    @targets = {}
    datafile.each_line do |line|
      if line.include?("|") then
        sfx_object_id = line.split("|").first
        issn = line.split("|")[1]
        eissn = line.split("|")[2]
        link = line.split("|")[3]
        date_statement = line.split("|")[4]
        related = line.split("|")[5]
        free = line.split("|")[6]
        @set[sfx_object_id] = {:issn=>issn, :eissn=>eissn, :link => link, :date_statement => date_statement, :related => related, :free => free}
      end
    end
    targetsfile.each_line do |line|
      sfx_object_id = line.split("|").first.strip
      title = line.split(": ").first.split("|").last.strip
      tgts = Array(line.split(": ").last.strip)
      temp = @set[sfx_object_id].merge({:title => title, :targets => tgts}) unless @set[sfx_object_id].nil?
      @set[sfx_object_id] = temp
   end
  end

end
