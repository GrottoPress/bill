struct ItemResponse < ApiResponse
  def initialize(
    @credit_note : CreditNote? = nil,
    @credit_note_item : CreditNoteItem? = nil,
    @invoice : Invoice? = nil,
    @invoice_item : InvoiceItem? = nil,
    @message : String? = nil,
    @receipt : Receipt? = nil,
    @transaction : Transaction? = nil,
  )
  end

  private def status : Status
    Status::Success
  end

  private def data_json : NamedTuple
    data = super
    data = add_credit_note(data)
    data = add_credit_note_item(data)
    data = add_invoice(data)
    data = add_invoice_item(data)
    data = add_receipt(data)
    data = add_transaction(data)
    data
  end

  private def add_credit_note(data)
    @credit_note.try do |credit_note|
      data = data.merge({credit_note: CreditNoteSerializer.new(credit_note)})
    end

    data
  end

  private def add_credit_note_item(data)
    @credit_note_item.try do |credit_note_item|
      data = data.merge({
        credit_note_item: CreditNoteItemSerializer.new(credit_note_item)
      })
    end

    data
  end

  private def add_invoice(data)
    @invoice.try do |invoice|
      data = data.merge({invoice: InvoiceSerializer.new(invoice)})
    end

    data
  end

  private def add_invoice_item(data)
    @invoice_item.try do |invoice_item|
      data = data.merge({
        invoice_item: InvoiceItemSerializer.new(invoice_item)
      })
    end

    data
  end

  private def add_receipt(data)
    @receipt.try do |receipt|
      data = data.merge({receipt: ReceiptSerializer.new(receipt)})
    end

    data
  end

  private def add_transaction(data)
    @transaction.try do |transaction|
      data = data.merge({transaction: TransactionSerializer.new(transaction)})
    end

    data
  end
end
