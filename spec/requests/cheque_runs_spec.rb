require 'spec_helper'

describe '/cheque_runs' do

  before do
    fill_in_basic_auth
  end

  it "has a form that accepts and parses a cheque csv" do
    visit new_cheque_run_path
    attach_file('Cheque File', Rails.root.join('spec', 'fixtures', 'cheques.csv'))

    click_button 'Submit'
    cheque_run = ChequeRun.last

    current_path.should == cheque_run_path(cheque_run)
    page.should have_css("table#cheque_run tr", :count => cheque_run.cheques.size)
  end

end

describe '/cheque_runs/1' do

  let(:cheque_run) { ChequeRun.from_csv_file Rails.root.join('spec', 'fixtures', 'cheques.csv') }

  before do
    fill_in_basic_auth
    visit cheque_run_path cheque_run
  end

  it "displays the parsed csv with download links" do
    page.should have_css("table#cheque_run tr", :count => cheque_run.cheques.size)

    cheque = cheque_run.cheques.first

    within "tr#cheque_#{cheque.id}" do
      page.should have_css("td", :text => cheque.payee)
      page.should have_css("td", :text => cheque.description)
      page.should have_css("td", :text => cheque.date.to_s)
      page.should have_css("td", :text => /^#{cheque.amount}$/)
      page.should have_css("td a[href='#{cheque_path(cheque, :format => 'pdf')}']")

      click_link 'Download'
    end

    current_path.should == cheque_path(cheque, :format => 'pdf')
  end

end