require "../../spec_helper"

describe Bill::DeleteCreditNoteItem do
  it "deletes invoice item" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    credit_note_item =
      CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    DeleteCreditNoteItem.delete(
      CreditNoteItemQuery.preload_credit_note(credit_note_item)
    ) do |operation, _|
      operation.deleted?.should be_true
    end

    CreditNoteItemQuery.new.id(credit_note_item.id).any?.should be_false
  end
end
