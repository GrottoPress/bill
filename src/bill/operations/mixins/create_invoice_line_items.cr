# TODO: Remove this
#   See https://github.com/luckyframework/avram/pull/895
require "lucille/spec/avram/fake_params"

module Bill::CreateInvoiceLineItems
  macro included
    after_save create_line_items

    include Bill::NeedsLineItems
    include Bill::ValidateHasLineItems

    private def create_line_items(invoice : Bill::Invoice)
      line_items_to_create.each do |line_item|
        CreateInvoiceItemForParent.create!(
          FakeParams.new(line_item), # TODO: Replace with `Avram::Params`
          parent: self
        )
      end
    end
  end
end
