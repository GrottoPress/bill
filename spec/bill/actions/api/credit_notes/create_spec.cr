require "../../../../spec_helper"

describe Bill::Api::CreditNotes::Create do
  it "creates credit note" do
    invoice = CreateInvoice.create!(
      params(
        user_id: UserFactory.create.id,
        description: "New invoice",
        due_at: 3.days.from_now,
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "1",
        "price" => "999"
      }]
    )

    response = ApiClient.exec(
      Api::CreditNotes::Create,
      credit_note: {
        invoice_id: invoice.id,
        description: "New credit note"
      },
      line_items: [{
        description: "Item 1",
        quantity: 2,
        price_mu: 0.12
      }]
    )

    CreditNoteQuery.new.any?.should be_true
    CreditNoteItemQuery.new.any?.should be_true

    response.should send_json(
      200,
      data: {credit_note: {type: "CreditNoteSerializer"}}
    )
  end
end
