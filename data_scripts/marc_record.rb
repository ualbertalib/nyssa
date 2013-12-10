require "marc"

class MarcRecord

  def initialize(record)
    @record = record
  end

  def sfx_object_id
    @record['090']['a'] if @record['090']
  end

  def electronicISSN
    @record['776']['x'] if @record['776']
  end

  def issnPrint
    @record['022']['a'] if @record['022']
  end

  def title
    @record['245']['a'].gsub(">","").gsub("<", "") if @record['245']
  end

  def language
    @record['008'].to_s[-5..-3] if @record['008']
  end

  def targets
    target_list = []
    if @record['866'] then
      tgts = @record.find_all{|t| ('866') === t.tag}
      tgts.each{|t| target_list << t['x'].to_s }
      target_list.join(", ")
    else
      target_list << "No targets"
    end
    target_list
  end
end
