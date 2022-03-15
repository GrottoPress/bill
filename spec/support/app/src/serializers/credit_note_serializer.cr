struct CreditNoteSerializer < SuccessSerializer
  def initialize(
    @credit_note : CreditNote? = nil,
    @credit_notes : Array(CreditNote)? = nil,
    @message : String? = nil,
    @pages : Lucky::Paginator? = nil,
  )
  end

  def self.item(credit_note : CreditNote)
    {type: credit_note.class.name}
  end

  private def data_json : NamedTuple
    data = super
    data = add_credit_note(data)
    data = add_credit_notes(data)
    data
  end

  private def add_credit_note(data)
    @credit_note.try do |credit_note|
      data = data.merge({credit_note: self.class.item(credit_note)})
    end

    data
  end

  private def add_credit_notes(data)
    @credit_notes.try do |credit_notes|
      data = data.merge({credit_notes: self.class.list(credit_notes)})
    end

    data
  end
end
