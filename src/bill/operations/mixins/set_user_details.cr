module Bill::SetUserDetails
  macro included
    include Bill::SetUserFromUserId

    before_save do
      set_user_details
    end

    private def set_user_details
      return if record.try(&.finalized?)

      @user.try do |user|
        user_details.value = <<-TEXT
          #{user.full_name}
          #{user.full_address}
          TEXT
      end
    end
  end
end
