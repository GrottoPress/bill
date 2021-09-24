module Bill::SetBusinessDetails
  macro included
    before_save do
      set_business_details
    end

    private def set_business_details
      return if record.try(&.finalized?)

      business_details.value = <<-TEXT
        #{Bill.settings.business_name}
        #{Bill.settings.business_address}
        TEXT
    end
  end
end
