require "../../../spec_helper"

describe Bill::CreditNotes::Update do
  it "updates credit note" do
    new_description = "Another credit note"

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .description("New credit note")

    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)

    response = ApiClient.exec(
      CreditNotes::Update.with(credit_note_id: credit_note.id),
      credit_note: {description: new_description}
    )

    credit_note.reload.description.should eq(new_description)
    response.status.should eq(HTTP::Status::FOUND)
  end
end
