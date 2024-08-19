{% unless Avram::Model.all_subclasses.find(&.name.== :InvoiceItem.id) %}
  {% skip_file %}
{% end %}

require "./common"

class InvoiceItemQuery < InvoiceItem::BaseQuery
  include Bill::InvoiceItemQuery
end

class CreateInvoiceItem < InvoiceItem::SaveOperation
  include Bill::CreateInvoiceItem
end

class CreateInvoiceItemForParent < InvoiceItem::SaveOperation
  include Bill::CreateInvoiceItemForParent
end

class UpdateInvoiceItem < InvoiceItem::SaveOperation
  include Bill::UpdateInvoiceItem
end

class UpdateFinalizedInvoiceItem < InvoiceItem::SaveOperation
  include Bill::UpdateFinalizedInvoiceItem
end

class UpdateInvoiceItemForParent < InvoiceItem::SaveOperation
  include Bill::UpdateInvoiceItemForParent
end

class DeleteInvoiceItem < InvoiceItem::DeleteOperation
  include Bill::DeleteInvoiceItem
end

class DeleteInvoiceItemForParent < InvoiceItem::DeleteOperation
  include Bill::DeleteInvoiceItemForParent
end
