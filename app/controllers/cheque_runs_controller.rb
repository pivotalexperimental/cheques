class ChequeRunsController < ApplicationController

  respond_to :html, :zip
  
  def new
  end

  def index
    @cheque_runs = current_user.cheque_runs
  end

  def create
    @cheque_run = ChequeRun.from_csv_file(params[:upload_input], current_user)
    redirect_to cheque_run_path(@cheque_run)
  end

  def show
    @cheque_run = ChequeRun.find params[:id]

    respond_with @cheque_run do |format|
      format.zip {
        tempfile = @cheque_run.to_tempfile
        send_file tempfile.path,
                  :type => 'application/zip',
                  :filename => "cheque_run_#{@cheque_run.id}.zip"
        tempfile.close

        @cheque_run.destroy
      }
    end

  end
  
end
