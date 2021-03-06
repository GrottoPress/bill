module Bill::CreateFinalizedCreditNoteTransaction
  macro included
    after_save create_transaction

    private def create_transaction(credit_note : Bill::CreditNote)
      return unless CreditNoteStatus.now_finalized?(status)
      return if (amount = credit_note.amount!).zero?

      CreateCreditTransaction.create!(
        user_id: credit_note.invoice!.user_id,
        description: credit_note.description,
        type: TransactionType.new(:credit_note),
        amount: amount,
        metadata: TransactionMetadata.from_json({
          credit_note_id: credit_note.id
        }.to_json)
      )
    end
  end
end
