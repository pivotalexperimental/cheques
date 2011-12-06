require 'prawn'
include Prawn::Measurements


FONT_SIZE = 12
BUFFER = 0.5
DATE_SPACING = 10

# all measurements in cm
# positions are taken from the bottom right corner
DOC_SIZE = [17.8, 8.8]

OPTIONS = {
  payee_name: {
    position: [0.5, 6.6],
    dimensions: [9, 1.5]
  },
  amount_text: {
    position: [1.1, 4.5],
    dimensions: [8.3, 1.1]
  },
  amount_num: {
    position: [11.7, 4.6]
  },
  date: {
    position: [12.6, 6.9]
  }
}

LINE_OPTIONS = {
  cross: {
    start: [0, 6.8],
    end: [2.0, 8.8]
  },
  bearer: {
    start: [11.1, 5.65],
    end: [12.3, 5.65]
  }

}

def transpose
  DOC_SIZE.reverse!
  OPTIONS.keys.each do |k|
    OPTIONS[k][:position].reverse!
    OPTIONS[k][:position][0] = DOC_SIZE[0] - OPTIONS[k][:position][0]
  end

  LINE_OPTIONS.keys.each do |k|
    LINE_OPTIONS[k].keys.each do |j|
      LINE_OPTIONS[k][j].reverse!
      LINE_OPTIONS[k][j][0] = DOC_SIZE[0] - LINE_OPTIONS[k][j][0]
    end
  end
end

def prepare
  OPTIONS.keys.each do |k|
    OPTIONS[k][:position].map! { |v| cm2pt(v) + FONT_SIZE + BUFFER}
    OPTIONS[k][:dimensions].map! { |v| cm2pt(v) + FONT_SIZE + BUFFER} if OPTIONS[k].has_key?(:dimensions)
  end

  LINE_OPTIONS.keys.each do |k|
    LINE_OPTIONS[k].keys.each do |j|
      LINE_OPTIONS[k][j].map! { |v| cm2pt(v) }
    end
  end
  
  DOC_SIZE.map! { |v| cm2pt(v) }

  transpose
end

def draw_date(date_string)
  x = OPTIONS[:date][:position][0]
  y = OPTIONS[:date][:position][1]
  date_string.chars.each_with_index do |c, i|
    text_box c, :at => [x, y + i * DATE_SPACING], :size => FONT_SIZE, :rotate => 90
  end
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

def draw_crosses
  first_line = LINE_OPTIONS[:cross]
  
  stroke_line first_line[:start], first_line[:end]
  stroke_line first_line[:start].tap { |l| l[0] -= 8 }, first_line[:end].tap { |l| l[1] -= 8 }
end

def draw_bearer_line
  line = LINE_OPTIONS[:bearer]
  stroke_line line[:start], line[:end]
end

prepare

Prawn::Document.generate("test.pdf",
                         :page_size => DOC_SIZE,
                         :margin => 0
) do
  draw_content :payee_name, "A very very very very very very very very very very very very very very very long name"
  #draw_content :amount_text, "One Thousand and Fifty Only**"
  #draw_date("1 1 0 4 1 1")
  #draw_content :amount_num, "**1,050.00"

  #draw_crosses
  #draw_bearer_line
end
