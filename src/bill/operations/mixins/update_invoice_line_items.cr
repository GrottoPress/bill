# TODO: Remove this
#   See https://github.com/luckyframework/avram/pull/895
require "lucille/spec/avram/fake_params"

module Bill::UpdateInvoiceLineItems
  macro included
    after_save update_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def update_line_items(invoice : Bill::Invoice)
      delete_items(invoice)
      update_items(invoice)
      create_items(invoice)
    end

    private def delete_items(invoice)
      line_items_to_delete.each do |line_item|
        invoice_item_from_hash(line_item, invoice).try do |invoice_item|
          DeleteInvoiceItemForParent.delete!(invoice_item, parent: self)
        end
      end
    end

    private def update_items(invoice)
      line_items_to_update.each do |line_item|
        invoice_item_from_hash(line_item, invoice).try do |invoice_item|
          UpdateInvoiceItemForParent.update!(
            invoice_item,
            FakeParams.new(line_item), # TODO: Replace with `Avram::Params`
            parent: self
          )
        end
      end
    end

    private def create_items(invoice)
      line_items_to_create.each do |line_item|
        CreateInvoiceItemForParent.create!(
          FakeParams.new(line_item), # TODO: Replace with `Avram::Params`
          parent: self
        )
      end
    end

    private def invoice_item_from_hash(hash, invoice)
      hash["id"]?.try do |id|
        InvoiceItemQuery.new.id(id).invoice_id(invoice.id).first?
      end
    end
  end
end
