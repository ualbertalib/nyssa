class MarcRecord

  attr_accessor :object_id, :title, :issnPrint, :issnElectronic, :targets

  def initialize
    @object_id = ""
    @title = ""
    @issnPrint = ""
    @issnElectronic = ""
    @targets = []
  end

end
