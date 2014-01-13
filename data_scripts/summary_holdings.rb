class SummaryHoldings

  attr_reader :data

  def initialize(data_file)
    @data = eval(data_file.read)
  end

  def statement(object_id)
    if data[object_id] then
      summaryHoldings = data[object_id][:summary_holdings]
      if summaryHoldings == "-PROBLEM RECORD-"
        return ""
      else
        years = summaryHoldings.scan(/\d{4}/)
        statement = String.new("")
        (statement = summaryHoldings.split("-")[1] if summaryHoldings.split("-")[1] !~ /\d{4}/) unless summaryHoldings.split("-")[1].nil?
	return parse(years, statement)
      end
    else
      return "Not found in summary holdings file"
    end
  end

  private

  def parse(years, statement)
    return "#{years[0]}".strip if (years.size==1 and statement.include?("only"))
    return "#{years[0]}- #{statement}".strip if (years.size==1 and !statement.include?("only"))
    return "#{years[0]}-#{years[1]}".strip if years.size==2
    return "#{years[0]}-#{years[1]}, #{years[2]}-".strip if years.size==3
    return "#{years[0]}-#{years[1]}, #{years[2]}-#{years[3]}".strip if years.size==4
    return "#{years.first}-#{years.last}".strip if years.size > 4
  end
end
