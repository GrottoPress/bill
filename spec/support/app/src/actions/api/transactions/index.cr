class Api::Transactions::Index < ApiAction
  include Bill::Api::Transactions::Index

  param page : Int32 = 1

  get "/transactions" do
    json({
      status: "success",
      data: {
        transactions: TransactionSerializer.for_collection(transactions)
      },
      pages: {
        current: page,
        total: pages.total
      }
    })
  end
end
