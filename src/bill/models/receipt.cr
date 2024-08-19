module Bill::Receipt
  macro included
    include Bill::ReferenceColumns

    {% if Avram::Model.all_subclasses.find(&.name.== :User.id) %}
      include Bill::BelongsToUser
    {% end %}

    column amount : Amount
    column business_details : String
    column description : String
    column notes : String?
    column status : ReceiptStatus
    column user_details : String

    delegate :draft?, :open?, :finalized?, to: status

    def amount_fm
      FractionalMoney.new(amount)
    end
  end
end
