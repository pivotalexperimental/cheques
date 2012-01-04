class ChequesController < ApplicationController

  respond_to :pdf

  def show
    @cheque = Cheque.find params[:id]
    send_data @cheque.to_prawn.render,
              disposition: 'inline',
              type: 'application/pdf'
  end

end
