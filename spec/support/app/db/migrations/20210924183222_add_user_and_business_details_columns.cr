class AddUserAndBusinessDetailsColumns::V20210924183222 < Avram::Migrator::Migration::V1
  def migrate
    alter :invoices do
      add user_details : String, default: "Kumasi, Ghana"
      add business_details : String, default: "KL, Malaysia"
    end

    alter :receipts do
      add user_details : String, default: "Kumasi, Ghana"
      add business_details : String, default: "KL, Malaysia"
    end
  end

  def rollback
    alter :invoices do
      remove :user_details
      remove :business_details
    end

    alter :receipts do
      remove :user_details
      remove :business_details
    end
  end
end
