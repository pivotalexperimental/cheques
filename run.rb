require "#{File.dirname(__FILE__)}/lib/csv_cheque"

cheque = Cheque.new("2011-01-01", "Winston", "1234.56")
cheque.to_pdf
