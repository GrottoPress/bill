struct CreditNoteItemSerializer < SuccessSerializer
  def initialize(
    @credit_note_item : CreditNoteItem? = nil,
    @credit_note_items : Array(CreditNoteItem)? = nil,
    @message : String? = nil,
    @pages : Lucky::Paginator? = nil,
  )
  end

  def self.item(credit_note_item : CreditNoteItem)
    {type: credit_note_item.class.name}
  end

  private def data_json : NamedTuple
    data = super
    data = add_credit_note_item(data)
    data = add_credit_note_items(data)
    data
  end

  private def add_credit_note_item(data)
    @credit_note_item.try do |credit_note_item|
      data = data.merge({credit_note_item: self.class.item(credit_note_item)})
    end

    data
  end

  private def add_credit_note_items(data)
    @credit_note_items.try do |credit_note_items|
      data = data.merge({credit_note_items: self.class.list(credit_note_items)})
    end

    data
  end
end
