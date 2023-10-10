require "../../../spec_helper"

describe Bill::FinalizedTransactions::Edit do
  it "edits finalized transaction" do
    user = UserFactory.create
    transaction = TransactionFactory.create &.user_id(user.id).status(:open)

    response = ApiClient.exec(FinalizedTransactions::Edit.with(
      transaction_id: transaction.id
    ))

    response.body.should eq("FinalizedTransactions::EditPage")
  end
end
