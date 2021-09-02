module Bill::BelongsToUser
  macro included
    belongs_to user : User
  end
end
