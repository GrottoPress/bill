struct InvoiceSerializer < SuccessSerializer
  def initialize(
    @invoice : Invoice? = nil,
    @invoices : Array(Invoice)? = nil,
    @message : String? = nil,
    @pages : Lucky::Paginator? = nil,
  )
  end

  def self.item(invoice : Invoice)
    {type: invoice.class.name}
  end

  private def data_json : NamedTuple
    data = super
    data = add_invoice(data)
    data = add_invoices(data)
    data
  end

  private def add_invoice(data)
    @invoice.try do |invoice|
      data = data.merge({invoice: self.class.item(invoice)})
    end

    data
  end

  private def add_invoices(data)
    @invoices.try do |invoices|
      data = data.merge({invoices: self.class.list(invoices)})
    end

    data
  end
end
