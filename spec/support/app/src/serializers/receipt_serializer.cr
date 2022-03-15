struct ReceiptSerializer < SuccessSerializer
  def initialize(
    @receipt : Receipt? = nil,
    @receipts : Array(Receipt)? = nil,
    @message : String? = nil,
    @pages : Lucky::Paginator? = nil,
  )
  end

  def self.item(receipt : Receipt)
    {type: receipt.class.name}
  end

  private def data_json : NamedTuple
    data = super
    data = add_receipt(data)
    data = add_receipts(data)
    data
  end

  private def add_receipt(data)
    @receipt.try do |receipt|
      data = data.merge({receipt: self.class.item(receipt)})
    end

    data
  end

  private def add_receipts(data)
    @receipts.try do |receipts|
      data = data.merge({receipts: self.class.list(receipts)})
    end

    data
  end
end
