module Bill::User
  abstract def billing_details : String

  macro included
  end
end
