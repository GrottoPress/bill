struct CreditNoteSerializer < BaseSerializer
  def initialize(@credit_note : CreditNote)
  end

  def render
    {type: "CreditNoteSerializer"}
  end
end
