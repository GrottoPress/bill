module Bill::ValidateNotes
  macro included
    skip_default_validations

    before_save do
      validate_notes_length
    end

    private def validate_notes_length
      max = 4094

      validate_size_of notes,
        max: max,
        message: Rex.t(:"operation.error.notes_too_long", max: max)
    end
  end
end
