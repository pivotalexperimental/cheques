require "#{File.dirname(__FILE__)}/lib/cheques"
require "csv"

filename = "#{File.dirname(__FILE__)}/csv/cheques.csv"

cheques = 0
CSV.foreach(filename, headers: true, skip_blanks: true) do |line|
  date   = line["Date"]
  payee  = line["Name"]
  desc   = line["Description"]
  amount = line["Amount"]

  next if payee.nil? || payee.empty?

  puts "==> PDF-ing cheque for #{payee}, desc: #{desc}, dated #{date}, amount #{amount}\n"
  cheque = PrintableCheque.new(date, payee, desc, amount)
  cheque.to_pdf

  cheques += 1
end

puts "=====> Total Cheques PDF-ed: #{cheques}"
