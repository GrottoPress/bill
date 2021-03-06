require "../../../../spec_helper"

describe Bill::Api::CreditNotes::Delete do
  it "deletes credit note" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(invoice.id).price(999)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(
      Api::CreditNotes::Delete.with(credit_note_id: credit_note.id)
    )

    # ameba:disable Performance/AnyInsteadOfEmpty
    CreditNoteQuery.new.id(credit_note.id).any?.should be_false

    response.should send_json(
      200,
      message: "action.credit_note.destroy.success"
    )
  end
end
