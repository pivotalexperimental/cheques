class ChequeRunsController < ApplicationController

  def create
    @cheque_run = ChequeRun.from_csv_file(params[:upload_input])
    redirect_to cheque_run_path(@cheque_run)
  end

  def new
  end

  def show
    @cheque_run = ChequeRun.find(params[:id])
  end
end
