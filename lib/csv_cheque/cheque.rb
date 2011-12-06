require 'prawn'
include Prawn::Measurements

class Cheque

  # constants
  FONT_SIZE     = 11
  BUFFER        = 0.5
  DATE_SPACING  = 20

  # all measurements in cm
  # positions are taken from the bottom left corner, in portrait mode
  DOC_SIZE = [8.8, 17.8]

  OPTIONS = {
    payee: {
      position: [1.4, 0.5],
      dimensions: [10, 1.5]
    },
    amount_text: {
      position: [3.4, 1.0],
      dimensions: [8.2, 1.0]
    },
    amount_number: {
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

  attr_reader :date, :payee, :amount_number, :amount_text

  def initialize(date, payee, amount)
    convert_cm2pt
    @date   = TextFormatter.date_to_ddmmyy(date)
    @payee  = payee
    @amount_text    = TextFormatter.amount_to_text(amount)
    @amount_number  = TextFormatter.amount_to_number(amount)
  end

  def to_pdf
    Prawn::Document.generate("test.pdf", :page_size => DOC_SIZE, :margin => 0) do |pdf|
      draw_date pdf, @date
      draw_content pdf, :payee, @payee
      draw_content pdf, :amount_text, @amount_text
      draw_content pdf, :amount_number, @amount_number
      draw_crosses pdf
      draw_bearer_line pdf
    end
  end

  def convert_cm2pt
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

  def draw_content(pdf, type, content)
    type_options = OPTIONS[type]
    position = type_options[:position]
    height = nil; width = nil

    if type_options.has_key?(:dimensions)
      height = type_options[:dimensions][1]
      width  = type_options[:dimensions][0]
    end

    pdf.text_box content, :at => position, :height => height, :width => width, :size => FONT_SIZE, :rotate => 90, :leading => 20
  end

  def draw_date(pdf, date_string)
    x = OPTIONS[:date][:position][0]
    y = OPTIONS[:date][:position][1]
    date_string.chars.each_with_index do |c, i|
      pdf.text_box c, :at => [x, y + i * DATE_SPACING], :size => FONT_SIZE, :rotate => 90
    end
  end

  def draw_crosses(pdf)
    first_line = LINE_OPTIONS[:cross]

    pdf.stroke_line first_line[:start], first_line[:end]
    pdf.stroke_line first_line[:start].tap { |l| l[0] -= 8 }, first_line[:end].tap { |l| l[1] -= 8 }
  end

  def draw_bearer_line(pdf)
    line = LINE_OPTIONS[:bearer]
    pdf.stroke_line line[:start], line[:end]
  end
end
