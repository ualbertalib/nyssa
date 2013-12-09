class MarcRecord

  def initialize(record)
    @record = record
  end

  def sfx_object_id
    @record['090']['a'] || ""
  end

  def electronicISSN
    @record['776']['a'] || ""
  end

  def issnPrint
    @record['022']['a'] || ""
  end

  def title
    @record['245']['a'].gsub(">","").gsub("<", "") || ""
  end

  def language
    @record['008'].to_s[-5..-3] || ""
  end

  def targets
    tgts = @record.find_all{|t| ('866') === t.tag}
    target_list = []
    tgts.each{|t| target_list << t['x'].to_s }
    target_list.join(", ")
  end

end
