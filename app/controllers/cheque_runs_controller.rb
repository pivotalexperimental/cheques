class ChequeRunsController < ApplicationController

  def create
    @cheque_run = ChequeRun.create
    redirect_to cheque_run_path(@cheque_run)
  end

end
