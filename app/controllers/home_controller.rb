class HomeController < ApplicationController
  def index
    redirect_to new_cheque_run_path
  end

end
