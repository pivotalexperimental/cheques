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
      dimensions: [9.5, 1.5]
    },
    amount_text: {
      position: [3.4, 1.5],
      dimensions: [8.2, 1.5]
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
    @date   = ChequeFormatter.date_to_ddmmyy(date)
    @payee  = payee
    @amount_text    = ChequeFormatter.amount_to_text(amount)
    @amount_number  = ChequeFormatter.amount_to_number(amount)
  end

  def to_pdf
    filename = "#{File.dirname(__FILE__)}/../../cheques/#{@payee.downcase.gsub(/\s/, "_")}_#{rand(0.1).to_s[2,10]}.pdf"
    Prawn::Document.generate(filename, :page_size => doc_size_in_pt, :margin => 0) do |pdf|
      draw_date pdf, @date
      draw_content pdf, :payee, @payee
      draw_content pdf, :amount_text, @amount_text
      draw_content pdf, :amount_number, @amount_number
      draw_crosses pdf
      draw_bearer_line pdf
    end
  end

  def draw_date(pdf, date_string)
    x = options_in_pt[:date][:position][0]
    y = options_in_pt[:date][:position][1]
    date_string.chars.each_with_index do |c, i|
      pdf.text_box c, :at => [x, y + i * DATE_SPACING], :size => FONT_SIZE, :rotate => 90
    end
  end

  def draw_content(pdf, type, content)
    type_options = options_in_pt[type]
    position = type_options[:position]
    height = nil; width = nil

    if type_options.has_key?(:dimensions)
      height = type_options[:dimensions][1]
      width  = type_options[:dimensions][0]
    end

    pdf.text_box content, :at => position, :height => height, :width => width, :size => FONT_SIZE, :rotate => 90, :leading => 15
  end

  def draw_crosses(pdf)
    first_line = line_options_in_pt[:cross]

    pdf.stroke_line first_line[:start], first_line[:end]
    pdf.stroke_line first_line[:start].tap { |l| l[0] -= 8 }, first_line[:end].tap { |l| l[1] -= 8 }
  end

  def draw_bearer_line(pdf)
    line = line_options_in_pt[:bearer]
    pdf.stroke_line line[:start], line[:end]
  end

  private

  def doc_size_in_pt
    @doc_size ||= DOC_SIZE.map { |v| cm2pt(v) }
  end

  def options_in_pt
    @options unless @options.nil?

    @options = Marshal.load(Marshal.dump(OPTIONS)) # deep_copy
    @options.keys.each do |k|
      @options[k][:position].map! { |v| cm2pt(v) + FONT_SIZE + BUFFER}
      @options[k][:dimensions].map! { |v| cm2pt(v) + FONT_SIZE + BUFFER} if @options[k].has_key?(:dimensions)
    end
    @options
  end

  def line_options_in_pt
    @line_options unless @line_options.nil?

    @line_options = Marshal.load(Marshal.dump(LINE_OPTIONS)) # deep_copy
    @line_options.keys.each do |k|
      @line_options[k].keys.each do |j|
        @line_options[k][j].map! { |v| cm2pt(v) }
      end
    end
    @line_options
  end
end
