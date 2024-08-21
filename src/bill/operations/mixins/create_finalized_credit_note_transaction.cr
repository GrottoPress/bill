module Bill::CreateFinalizedCreditNoteTransaction
  macro included
    include Bill::CreditNoteDescription

    after_save create_transaction

    private def create_transaction(credit_note : Bill::CreditNote)
      return unless CreditNoteStatus.now_finalized?(status)
      return if (amount = credit_note.amount!).zero?

      CreateTransaction.create!(
        user_id: credit_note.invoice!.user_id,
        credit: true,
        description: credit_note_description(credit_note),
        type: TransactionType.new(:credit_note),
        status: TransactionStatus.new(:open),
        amount: amount,
        source: credit_note.id.to_s
      )
    end
  end
end
