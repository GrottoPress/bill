struct ListResponse < ApiResponse
  def initialize(
    @pages : Lucky::Paginator,
    @credit_notes : Array(CreditNote)? = nil,
    @credit_note_items : Array(CreditNoteItem)? = nil,
    @invoices : Array(Invoice)? = nil,
    @invoice_items : Array(InvoiceItem)? = nil,
    @message : String? = nil,
    @receipts : Array(Receipt)? = nil,
    @transactions : Array(Transaction)? = nil,
  )
  end

  def render
    super.merge({pages: PaginationSerializer.new(@pages)})
  end

  private def status : Status
    Status::Success
  end

  private def data_json : NamedTuple
    data = super
    data = add_credit_notes(data)
    data = add_credit_note_items(data)
    data = add_invoices(data)
    data = add_invoice_items(data)
    data = add_receipts(data)
    data = add_transactions(data)
    data
  end

  private def add_credit_notes(data)
    @credit_notes.try do |credit_notes|
      data = data.merge({credit_notes: CreditNoteSerializer.list(credit_notes)})
    end

    data
  end

  private def add_credit_note_items(data)
    @credit_note_items.try do |credit_note_items|
      data = data.merge({
        credit_note_items: CreditNoteItemSerializer.list(credit_note_items)
      })
    end

    data
  end

  private def add_invoices(data)
    @invoices.try do |invoices|
      data = data.merge({invoices: InvoiceSerializer.list(invoices)})
    end

    data
  end

  private def add_invoice_items(data)
    @invoice_items.try do |invoice_items|
      data = data.merge({
        invoice_items: InvoiceItemSerializer.list(invoice_items)
      })
    end

    data
  end

  private def add_receipts(data)
    @receipts.try do |receipts|
      data = data.merge({receipts: ReceiptSerializer.list(receipts)})
    end

    data
  end

  private def add_transactions(data)
    @transactions.try do |transactions|
      data = data.merge({
        transactions: TransactionSerializer.list(transactions)
      })
    end

    data
  end
end
