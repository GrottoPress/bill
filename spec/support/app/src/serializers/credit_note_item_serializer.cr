class CreditNoteItemSerializer < BaseSerializer
  def initialize(@credit_note_item : CreditNoteItem)
  end

  def render
    {type: "CreditNoteItemSerializer"}
  end
end
