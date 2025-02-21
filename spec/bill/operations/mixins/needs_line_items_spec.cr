require "../../../spec_helper"

private class SaveInvoice < Invoice::SaveOperation
  permit_columns :user_id,
    :business_details,
    :description,
    :due_at,
    :reference,
    :status,
    :user_details

  include Bill::CreateInvoiceLineItems
end

describe Bill::NeedsLineItems do
  it "collects many nested operation errors" do
    user = UserFactory.create

    SaveInvoice.create(
      params(
        user_id: user.id,
        business_details: "ACME Inc",
        description: "New Invoice",
        due_at: 3.days.from_now,
        status: :open
      ),
      line_items: [{
        "description" => "Item 1",
        "quantity" => "2",
        "price" => "-1"
      }]
    ) do |operation, invoice|
      invoice.should be_nil

      operation.save_line_items.first?.should be_a(CreateInvoiceItemForParent)
      operation.many_nested_errors[:save_line_items].first?.should_not be_nil

      operation.many_nested_errors[:save_line_items]
        .first[:price]
        .should(contain "operation.error.price_lte_zero")

      operation.save_line_items
        .first
        .price
        .should(have_error "operation.error.price_lte_zero")
    end
  end
end
