require 'date'
require 'linguistics'
Linguistics::use( :en ) # extends Array, String, and Numeric

class ChequeFormatter
  class << self

    def date_to_ddmmyy(date)
      DateTime.parse(date).strftime("%d%m%y")
    end

    def amount_to_text(number)
      dollars, cents = dollars_and_cents number

      text = "#{dollars.en.numwords} and cents #{cents.en.numwords} only"
      text.gsub(/\b[a-z]+/){ |w| w.capitalize }.gsub(",", "").gsub("-", " ")
    end

    def amount_to_number(number)
      dollars, cents = dollars_and_cents number
      dollars.gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")

      "#{dollars}.#{cents}"
    end

    private

    def dollars_and_cents(number)
      ("%.2f" % number.to_f.abs).split('.')
    end
  end
end
