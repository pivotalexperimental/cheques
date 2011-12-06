require "#{File.dirname(__FILE__)}/lib/csv_cheque"
require "csv"

filename = "#{File.dirname(__FILE__)}/csv/cheques.csv"

cheques = 0
CSV.foreach(filename, headers: true, skip_blanks: true) do |line|
  date   = line["Date"]
  payee  = line["Name"]
  amount = line["Amount"]

  next if payee.nil? || payee.empty?

  puts "==> PDF-ing cheque for #{payee}, dated #{date}, amount #{amount}\n"
  cheque = Cheque.new(date, payee, amount)
  cheque.to_pdf

  cheques += 1
end

puts "=====> Total Cheques PDF-ed: #{cheques}"
