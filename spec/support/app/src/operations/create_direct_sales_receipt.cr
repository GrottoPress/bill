class CreateDirectSalesReceipt < Invoice::SaveOperation
  include Bill::CreateDirectSalesReceipt
end
