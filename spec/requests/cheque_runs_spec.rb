require 'spec_helper'

describe "/cheque_runs resource" do

  include Warden::Test::Helpers
  after { Warden.test_reset! }
  
  before do
    fill_in_basic_auth
    login_as User.create(email: "email@example.com", password: "foobar")
  end

  describe '/cheque_runs' do
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
      visit cheque_run_path cheque_run
    end

    it "displays the parsed csv" do
      cheque_run.cheques.each do |cheque|
        within "tr#cheque_#{cheque.id}" do
          page.should have_css("td", :text => cheque.payee)
          page.should have_css("td", :text => cheque.description)
          page.should have_css("td", :text => cheque.date.to_s)

          amount = number_to_currency cheque.amount
          page.should have_css("td.amount", :text => amount)
        end
      end
    end

    it "has preview links" do
      cheque_run.cheques.each do |cheque|
        within "tr#cheque_#{cheque.id}" do
          page.should have_css("td a[href='#{cheque_path(cheque, :format => 'pdf')}']", :text => "Preview")
        end
      end
    end

    it "has a download all link" do
      page.should have_css("a[href='#{cheque_run_path(cheque_run, :format => 'zip')}']")
    end

    context "following the download link" do
      before do
        click_link "Download All"
      end

      it "redirects to root on reload" do
        visit current_path
        current_path.should == root_path
      end

    end

  end
end
