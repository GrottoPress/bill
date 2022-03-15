struct InvoiceItemSerializer < SuccessSerializer
  def initialize(
    @invoice_item : InvoiceItem? = nil,
    @invoice_items : Array(InvoiceItem)? = nil,
    @message : String? = nil,
    @pages : Lucky::Paginator? = nil,
  )
  end

  def self.item(invoice_item : InvoiceItem)
    {type: invoice_item.class.name}
  end

  private def data_json : NamedTuple
    data = super
    data = add_invoice_item(data)
    data = add_invoice_items(data)
    data
  end

  private def add_invoice_item(data)
    @invoice_item.try do |invoice_item|
      data = data.merge({invoice_item: self.class.item(invoice_item)})
    end

    data
  end

  private def add_invoice_items(data)
    @invoice_items.try do |invoice_items|
      data = data.merge({invoice_items: self.class.list(invoice_items)})
    end

    data
  end
end
