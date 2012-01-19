class ChequesController < ApplicationController

  respond_to :pdf

  def show
    @cheque = Cheque.find params[:id]
    render_403 and return unless @cheque.cheque_run.from_organization?(current_user.organization)

    send_data @cheque.to_prawn.render,
              disposition: 'inline',
              type: 'application/pdf'
  end

end
