require 'csv'
require 'prawn'
include Prawn::Measurements

# constants
FONT_SIZE     = 11
BUFFER        = 0.5
DATE_SPACING  = 10

# all measurements in cm
# positions are taken from the bottom left corner, in portrait mode
DOC_SIZE = [8.8, 17.8]

OPTIONS = {
  payee_name: {
    position: [1.4, 0.5],
    dimensions: [10, 1.5]
  },
  amount_text: {
    position: [3.4, 1.0],
    dimensions: [8.2, 1.0]
  },
  amount_num: {
    position: [3.4, 12.0]
  },
  date: {
    position: [1.0, 12.5]
  }
}

LINE_OPTIONS = {
  cross: {
    start: [2.0 , 0],
    end: [0.0, 2.0]
  },
  bearer: {
    start: [3.15, 11.1],
    end: [3.15, 12.3]
  }
}

def prepare
  DOC_SIZE.map! { |v| cm2pt(v) }

  OPTIONS.keys.each do |k|
    OPTIONS[k][:position].map! { |v| cm2pt(v) + FONT_SIZE + BUFFER}
    OPTIONS[k][:dimensions].map! { |v| cm2pt(v) + FONT_SIZE + BUFFER} if OPTIONS[k].has_key?(:dimensions)
  end

  LINE_OPTIONS.keys.each do |k|
    LINE_OPTIONS[k].keys.each do |j|
      LINE_OPTIONS[k][j].map! { |v| cm2pt(v) }
    end
  end
end

def read_csv
  #filename = prompt "Please enter the CSV filename: "
  filename = "/Users/pivotal/workspace/csv_cheque/cheques.csv"
  CSV.foreach(filename, headers: true, skip_blanks: true) do |line|
    p line
  end
end

def prompt(*args)
  print(*args)
  gets.strip
end

def draw_content(type, content)
  type_options = OPTIONS[type]
  position = type_options[:position]
  height = nil; width = nil

  if type_options.has_key?(:dimensions)
    height = type_options[:dimensions][1]
    width = type_options[:dimensions][0]
  end

  text_box content, :at => position, :height => height, :width => width, :size => FONT_SIZE, :rotate => 90, :leading => 20
end

def draw_date(date_string)
  x = OPTIONS[:date][:position][0]
  y = OPTIONS[:date][:position][1]
  date_string.chars.each_with_index do |c, i|
    text_box c, :at => [x, y + i * DATE_SPACING], :size => FONT_SIZE, :rotate => 90
  end
end

def draw_crosses
  first_line = LINE_OPTIONS[:cross]
  
  stroke_line first_line[:start], first_line[:end]
  stroke_line first_line[:start].tap { |l| l[0] -= 8 }, first_line[:end].tap { |l| l[1] -= 8 }
end

def draw_bearer_line
  line = LINE_OPTIONS[:bearer]
  stroke_line line[:start], line[:end]
end

read_csv

# Do work!
prepare

Prawn::Document.generate("test.pdf", :page_size => DOC_SIZE, :margin => 0) do
  draw_content :payee_name, "A very very very very very very very very very very very very very very very long name"
  draw_content :amount_text, "One Thousand and Fifty Only**"
  draw_date("1 1 0 4 1 1")
  draw_content :amount_num, "**1,050.00"
  draw_crosses
  draw_bearer_line
end
