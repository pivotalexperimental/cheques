class ChequeRun < ActiveRecord::Base
  has_many :cheques, :dependent => :destroy
  belongs_to :owner, :class_name => "User"

  def self.from_csv_file(file, owner)
    string = file.read
    self.from_csv_string(string, owner)
  end

  def self.from_csv_string(string, owner)
    cheque_run = ChequeRun.new
    CSV.parse(string, headers: true, skip_blanks: true).map do |line|
      date = line["Date"]
      payee = line["Name"]
      desc = line["Description"]
      amount = line["Amount"].to_f

      cheque = Cheque.new(
          :date => date,
          :payee => payee,
          :description => desc,
          :amount => -amount
      )

      cheque_run.cheques << cheque if cheque.valid?
    end

    cheque_run.owner = owner
    cheque_run.save
    return cheque_run
  end

  def to_tempfile
    temp = Tempfile.new id.to_s
    Zip::ZipOutputStream.open(temp.path) do |z|
      cheques.each do |cheque|
        z.put_next_entry cheque.filename
        z.write cheque.to_tempfile.read
      end
    end
    temp
  end
end
