class Cheque < ActiveRecord::Base
  belongs_to :cheque_run
  validates_presence_of :payee, :amount

  def to_prawn
    printable_cheque = PrintableCheque.new date.to_s, payee, description, amount
    printable_cheque.to_prawn
  end
end
