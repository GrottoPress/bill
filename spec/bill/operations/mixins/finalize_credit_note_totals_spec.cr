require "../../../spec_helper"

describe Bill::FinalizeCreditNoteTotals do
  it "updates totals" do
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

    credit_note = CreditNoteFactory.create &.invoice_id(invoice.id)
      .status(:open)

    CreditNoteItemFactory.create &.credit_note_id(credit_note.id)
      .quantity(1)
      .price(10)

    CreateCreditNote.create(
      params(
        invoice_id: invoice.id,
        description: "New credit note",
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "2",
        "price" => "12"
      }]
    ) do |_, credit_note|
      credit_note.should be_a(CreditNote)

      credit_note.try do |credit_note|
        credit_note.reload.totals.try do |totals|
          totals.line_items.should eq(2 * 12)
        end

        credit_note.invoice!.totals.try do |totals|
          totals.credit_notes.should eq(1 * 10 + 2 * 12)
        end
      end
    end
  end
end
