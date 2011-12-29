class AddChequeRunsAndCheques < ActiveRecord::Migration
  def self.up

    create_table :cheque_runs do |t|
      t.timestamps
    end

    create_table :cheques do |t|
      t.references :cheque_run
      t.date :date
      t.string :payee
      t.string :description
      t.float :amount
      t.timestamps
    end

  end

  def self.down
    drop_table :cheque_runs
    drop_table :cheques
  end
end
