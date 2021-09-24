module Bill::SetUserFromUserId
  macro included
    @user : User?

    before_save do
      set_user_from_user_id
    end

    private def set_user_from_user_id
      user_id.value.try do |value|
        @user ||= UserQuery.new.id(value).first?
      end
    end
  end
end
