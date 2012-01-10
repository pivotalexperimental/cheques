class AddOwnerIdToChequeRun < ActiveRecord::Migration
  def change
    add_column :cheque_runs, :owner_id, :integer
  end
end
