class AddChequeRunsAndCheques < ActiveRecord::Migration
  def self.up

    create_table :cheque_runs do |t|
      t.timestamps
    end

  end

  def self.down
    drop_table :cheque_runs
  end
end
