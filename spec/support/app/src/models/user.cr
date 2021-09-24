class User < BaseModel
  include Bill::User
  include Carbon::Emailable

  skip_default_columns

  primary_key id : Int64

  table :users do
    column email : String
  end

  def full_name
    "User ##{id}"
  end

  def full_address
    <<-TEXT
    No #{id} Street,
    Ghana.
    TEXT
  end

  def emailable : Carbon::Address
    Carbon::Address.new(email)
  end
end
