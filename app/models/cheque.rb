class Cheque < ActiveRecord::Base
  belongs_to :cheque_run
  validates_presence_of :payee, :amount

  def to_prawn
    printable_cheque = PrintableCheque.new date.to_s, payee, description, amount
    printable_cheque.to_prawn
  end

  def to_tempfile
    temp = Tempfile.new(id.to_s)
    temp.write to_prawn.render.force_encoding("UTF-8")
    temp.rewind
    temp
  end

  def filename
    "#{payee}_#{date.to_s(:file)}_#{id}.pdf"
  end
end
