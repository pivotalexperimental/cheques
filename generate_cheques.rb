require 'prawn'
include Prawn::Measurements


FONT_SIZE = 12
BUFFER = 1
DATE_SPACING = 10

# all measurements in cm
# positions are taken from the bottom right corner
DOC_SIZE = [17.8, 8.8]
OPTIONS = {
  payee_name_pos: [1.1, 6.7],
  payee_name_dimensions: [10, 1.5],
  amount_text_pos: [1.8, 4.6],
  amount_text_dimensions: [9.3, 1.1],
  amount_num_pos: [12.3, 4.6],
  date_pos: [12.8, 6.9]
}

def prepare
  OPTIONS.keys.each do |k|
    OPTIONS[k].map! { |v| cm2pt(v) + FONT_SIZE + BUFFER}
  end
  DOC_SIZE.map! { |v| cm2pt(v) }
end

def draw_date(date_string)
  x = OPTIONS[:date_pos][0]
  y = OPTIONS[:date_pos][1]
  date_string.chars.each_with_index do |c, i|
    text_box c, :at => [x + i * DATE_SPACING, y], :size => FONT_SIZE
  end
end

prepare

Prawn::Document.generate("test.pdf",
                         :page_size => DOC_SIZE,
                         :margin => 0
) do
  text_box "Payee Name", :at => OPTIONS[:payee_name_pos], :height => OPTIONS[:payee_name_dimensions][1], :width => OPTIONS[:payee_name_dimensions][0], :size => FONT_SIZE
  text_box "One Thousand and Fifty Only**", :at => OPTIONS[:amount_text_pos], :height => OPTIONS[:amount_text_dimensions][1], :width => OPTIONS[:amount_text_dimensions][0], :size => FONT_SIZE
  draw_date("1 1 0 4 1 1")
  text_box "**1,050", :at => OPTIONS[:amount_num_pos], :size => FONT_SIZE
end

