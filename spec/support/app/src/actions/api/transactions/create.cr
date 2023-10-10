class Api::Transactions::Create < ApiAction
  include Bill::Api::Transactions::Create

  post "/transactions" do
    run_operation
  end
end
