require "../../../spec_helper"

describe Bill::FinalizedCreditNotes::Update do
  it "updates finalized credit note" do
    new_description = "Another credit note"

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(invoice.id).price(999)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:open)

    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    response = ApiClient.exec(
      FinalizedCreditNotes::Update.with(credit_note_id: credit_note.id),
      credit_note: {description: new_description}
    )

    credit_note.reload.description.should eq(new_description)
    response.status.should eq(HTTP::Status::FOUND)
  end
end
