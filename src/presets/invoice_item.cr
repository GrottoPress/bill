{% skip_file unless Avram::Model.all_subclasses
  .map(&.stringify)
  .includes?("InvoiceItem")
%}

class User < BaseModel
  include Bill::UserInvoicesAccount
end

class Invoice < BaseModel
  include Bill::HasManyInvoiceItems
end

class InvoiceItemQuery < InvoiceItem::BaseQuery
  include Bill::InvoiceItemQuery
end

class CreateInvoice < Invoice::SaveOperation
  include Bill::CreateInvoiceLineItems
end

class UpdateInvoice < Invoice::SaveOperation
  include Bill::UpdateInvoiceLineItems
end

class UpdateInvoiceStatus < Invoice::SaveOperation
  include Bill::ValidateHasLineItems
end

class CreateInvoiceItem < InvoiceItem::SaveOperation
  include Bill::CreateInvoiceItem
end

class UpdateInvoiceItem < InvoiceItem::SaveOperation
  include Bill::UpdateInvoiceItem
end

class DeleteInvoiceItem < InvoiceItem::DeleteOperation
  include Bill::DeleteInvoiceItem
end

struct UserCashAccount
  include Bill::InvoicesCashAccount
end
