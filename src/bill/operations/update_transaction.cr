module Bill::UpdateTransaction
  macro included
    permit_columns :description

    include Bill::ValidateTransaction

    private def validate_not_update
    end
  end
end
