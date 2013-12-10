class BadIssn

  def initialize(file_name)
    @list = []
    file_name.each_line do |line|
      @list << line.split(" ")[2].split("|").first
    end
  end

  def ==(titleID)
    @list.include? titleID
  end

end
