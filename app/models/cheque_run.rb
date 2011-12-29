class ChequeRun < ActiveRecord::Base
  has_many :cheques

  def self.from_csv_file(file)
    string = file.read
    self.from_csv_string(string)
  end

  def self.from_csv_string(string)
    require 'csv' #TODO: alternatives?
    cheque_run = ChequeRun.new
    CSV.parse(string, headers: true, skip_blanks: true).map do |line|
      cheque_run.cheques << Cheque.create
    end

    cheque_run.save #TODO: should I?
    return cheque_run
  end
end
