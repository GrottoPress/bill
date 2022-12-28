module Bill::SetUserFromUserId
  macro included
    getter user : User? do
      user_id.value.try { |value| UserQuery.new.id(value).first? }
    end
  end
end
