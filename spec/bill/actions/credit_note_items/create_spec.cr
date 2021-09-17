require "../../../spec_helper"

describe Bill::CreditNoteItems::Create do
  it "creates credit note item" do
    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id)
    InvoiceItemFactory.create &.invoice_id(invoice.id).price(999)
    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)

    response = ApiClient.exec(
      CreditNoteItems::Create.with(credit_note_id: credit_note.id), credit_note_item: {
        description: "New credit note item",
        quantity: 2,
        price_mu: 3.33
      }
    )

    CreditNoteItemQuery.new.any?.should be_true
    response.status.should eq(HTTP::Status::FOUND)
  end
end
