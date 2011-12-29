require 'prawn'
include Prawn::Measurements

class PrintableCheque

  # constants
  FONT_SIZE     = 11
  BUFFER        = 0.5
  DATE_SPACING  = 20

  # all measurements in cm
  # positions are taken from the bottom left corner, in portrait mode
  DOC_SIZE = [8.8, 17.8]

  def initialize(date, payee, desc, amount, template=:default)
    @template = Template::BANKS[template]

    @date   = ChequeFormatter.date_to_ddmmyy(date)
    @payee  = payee
    @desc   = desc
    @amount_text    = ChequeFormatter.amount_to_text(amount)
    @amount_number  = ChequeFormatter.amount_to_number(amount)
  end

  def to_pdf
    filename = "#{File.dirname(__FILE__)}/../../cheques/#{@payee.downcase.gsub(/\s/, "_")}_#{rand(0.1).to_s[2,10]}.pdf"
    Prawn::Document.generate(filename, :page_size => doc_size_in_pt, :margin => 0) do |pdf|
      draw_date pdf, @date
      draw_content pdf, :payee, @payee
      draw_content pdf, :payee_only, "NOT NEGOTIABLE, A/C PAYEE ONLY"
      draw_content pdf, :desc, @desc if @desc
      draw_content pdf, :amount_text, @amount_text
      draw_content pdf, :amount_number, @amount_number
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

    font_size = type_options[:font_size] || FONT_SIZE

    pdf.text_box content, :at => position, :height => height, :width => width, :size => font_size, :rotate => 90, :leading => 15
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

    @options = Marshal.load(Marshal.dump(@template[:options])) # deep_copy
    @options.keys.each do |k|
      @options[k][:position].map! { |v| cm2pt(v) + FONT_SIZE + BUFFER}
      @options[k][:dimensions].map! { |v| cm2pt(v) + FONT_SIZE + BUFFER} if @options[k].has_key?(:dimensions)
    end
    @options
  end

  def line_options_in_pt
    @line_options unless @line_options.nil?

    @line_options = Marshal.load(Marshal.dump(@template[:lines])) # deep_copy
    @line_options.keys.each do |k|
      @line_options[k].keys.each do |j|
        @line_options[k][j].map! { |v| cm2pt(v) }
      end
    end
    @line_options
  end
end
