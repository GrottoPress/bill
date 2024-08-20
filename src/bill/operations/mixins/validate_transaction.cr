module Bill::ValidateTransaction
  macro included
    skip_default_validations

    before_save do
      validate_amount_required
      validate_description_required
      validate_status_required
      validate_type_required
      validate_user_id_required

      validate_amount_not_zero
    end

    include Bill::ValidateStatusTransition
    include Bill::ValidateReference
    include Bill::ValidateDescription
    include Lucille::ValidateUserExists

    private def validate_user_id_required
      validate_required user_id,
        message: Rex.t(:"operation.error.user_id_required")
    end

    private def validate_description_required
      validate_required description,
        message: Rex.t(:"operation.error.description_required")
    end

    private def validate_amount_required
      validate_required amount,
        message: Rex.t(:"operation.error.amount_required")
    end

    private def validate_status_required
      validate_required status,
        message: Rex.t(:"operation.error.status_required")
    end

    private def validate_type_required
      validate_required type, message: Rex.t(:"operation.error.type_required")
    end

    private def validate_amount_not_zero
      amount.value.try do |value|
        return unless value.zero?

        amount.add_error Rex.t(
          :"operation.error.amount_zero",
          amount: value,
          amount_fmt: FractionalMoney.new(value).to_s,
          amount_mu: FractionalMoney.new(value).amount_mu,
          currency_code: Bill.settings.currency.code,
          currency_sign: Bill.settings.currency.sign
        )
      end
    end
  end
end
