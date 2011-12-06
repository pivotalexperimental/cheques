require 'linguistics'
Linguistics::use( :en ) # extends Array, String, and Numeric

class TextFormatter
  def self.number_to_words(number)
    formatted = "%05.2f" % number
    dollars, cents = formatted.split '.'

    cheque_text = "#{dollars.en.numwords} and cents #{cents.en.numwords} only"
    titleize(strip_punctuations(cheque_text))
  end

  private

  def self.titleize(text)
    text.gsub(/\b[a-z]+/){ |w| w.capitalize }
  end

  def self.strip_punctuations(text)
    text.gsub(",", "").gsub("-", " ")
  end
end
