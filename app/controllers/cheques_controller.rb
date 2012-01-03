class ChequesController < ApplicationController

  def show
    @cheque = Cheque.find params[:id]
    send_data @cheque.to_prawn.render,
              filename: "#{@cheque.payee.downcase.gsub(/\s/, "_")}.pdf",
              type: 'application/pdf'

  end

end
