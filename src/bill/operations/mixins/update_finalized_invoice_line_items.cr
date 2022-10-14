# TODO: Remove this
#   See https://github.com/luckyframework/avram/pull/895
require "lucille/spec/avram/fake_params"

module Bill::UpdateFinalizedInvoiceLineItems
  macro included
    after_save update_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def update_line_items(invoice : Bill::Invoice)
      line_items_to_update.each do |line_item|
        invoice_item_from_hash(line_item, invoice).try do |invoice_item|
          UpdateFinalizedInvoiceItem.update!(
            invoice_item,
            FakeParams.new(line_item), # TODO: Replace with `Avram::Params`
          )
        end
      end
    end

    private def invoice_item_from_hash(hash, invoice)
      hash["id"]?.try do |id|
        InvoiceItem::PrimaryKeyType.adapter.parse(id).value.try do |id|
          InvoiceItemQuery.new.id(id).invoice_id(invoice.id).first?
        end
      end
    end
  end
end
