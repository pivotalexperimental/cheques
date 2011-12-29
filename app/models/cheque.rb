class Cheque < ActiveRecord::Base
  belongs_to :cheque_run
  validates_presence_of :payee, :amount
end
