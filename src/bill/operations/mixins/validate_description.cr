module Bill::ValidateDescription
  macro included
    skip_default_validations

    before_save do
      validate_description_length
    end

    private def validate_description_length
      max = 510

      validate_size_of description,
        max: max,
        message: Rex.t(:"operation.error.description_too_long", max: max)
    end
  end
end
