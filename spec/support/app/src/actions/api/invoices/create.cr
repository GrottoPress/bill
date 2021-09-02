class Api::Invoices::Create < ApiAction
  include Bill::Api::Invoices::Create

  post "/invoices" do
    run_operation
  end
end
