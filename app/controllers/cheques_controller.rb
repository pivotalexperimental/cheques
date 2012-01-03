class ChequesController < ApplicationController

  respond_to :pdf

  def show
    @cheque = Cheque.find params[:id]
    send_data @cheque.to_prawn.render,
              filename: @cheque.filename,
              type: 'application/pdf'
  end

end
