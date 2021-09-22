class Api::Receipts::Create < ApiAction
  include Bill::Api::Receipts::Create

  post "/receipts" do
    run_operation
  end
end
