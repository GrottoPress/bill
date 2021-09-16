class Transaction < BaseModel
  include Bill::Transaction

  skip_default_columns
  primary_key id : Int64

  table :transactions do
    column created_at : Time
  end
end
