require "../../spec_helper"

describe Bill::CreateCreditNote do
  it "creates new credit note" do
    description = "New credit note"
    notes = "A note"
    status = CreditNoteStatus.new(:draft)

    user = UserFactory.create
    invoice = InvoiceFactory.create &.user_id(user.id).status(:open)
    InvoiceItemFactory.create &.invoice_id(invoice.id).price(999)

    CreateCreditNote.create(
      params(
        invoice_id: invoice.id,
        description: description,
        notes: notes,
        status: status
      ),
      line_items: Array(Hash(String, String)).new
    ) do |_, credit_note|
      credit_note.should be_a(CreditNote)

      credit_note.try do |credit_note|
        credit_note.invoice_id.should eq(invoice.id)
        credit_note.description.should eq(description)
        credit_note.notes.should eq(notes)
        credit_note.status.should eq(status)
      end
    end
  end

  it "creates new credit note with line items" do
    description = "New credit note"
    notes = "A note"
    status = CreditNoteStatus.new(:open)

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

    CreateCreditNote.create(
      params(
        invoice_id: invoice.id,
        description: description,
        notes: notes,
        status: status
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "2",
        "price" => "12"
      }]
    ) do |_, credit_note|
      credit_note.should be_a(CreditNote)

      credit_note.try do |credit_note|
        credit_note.invoice_id.should eq(invoice.id)
        credit_note.description.should eq(description)
        credit_note.notes.should eq(notes)
        credit_note.status.should eq(status)

        credit_note.line_items!.size.should eq(1)
      end
    end
  end
end
