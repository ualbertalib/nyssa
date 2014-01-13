class HoldingErrors

  def initialize(filename)
    $/ = ""
    @list = {}
    filename.each_line do |line|
      titleID = line.chomp.split("|").first
      statement = line.chomp.split("|").last
      @list[titleID] = clean(statement) 
    end
  end

  def include?(titleID)
    @list.include? titleID 
  end

  def for(titleID)
    @list[titleID] || ""
  end

  private

  def clean(statement)
    statement.gsub("\n", ": ")
  end

end
