class User < BaseModel
  include Bill::User
  include Bill::HasManyCreditNotesThroughInvoices
  include Bill::HasManyInvoices
  include Bill::HasManyReceipts
  include Bill::HasManyTransactions

  include Carbon::Emailable

  skip_default_columns

  primary_key id : Int64

  table :users do
    column email : String
  end

  def full_name
    "User ##{id}"
  end

  def billing_details : String
    <<-TEXT
    #{full_name}
    <#{email}>
    No #{id} Street,
    Ghana.
    TEXT
  end

  def emailable : Carbon::Address
    Carbon::Address.new(email)
  end
end
