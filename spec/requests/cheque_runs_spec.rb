require 'spec_helper'

describe "/cheque_runs resource" do

  include Warden::Test::Helpers
  after { Warden.test_reset! }

  before do
    fill_in_basic_auth
    @user = User.create(email: "email@example.com", password: "foobar", first_name: "Donald", last_name: "Trump")
    login_as @user
  end

  describe '/cheque_runs' do
    it "has a list of cheque runs that the current user owns" do
      csv_string_3_cheques = <<CSV_DATA
Date,Chq No,Name,Description,Amount
4-Nov-2011,788981,IRAS,201012345D,-1160
4-Nov-2011,788987,Abhaya Shenoy REIMB,,-67.4
4-Nov-2011,788979,BBH (Hachi),,-3250
CSV_DATA
      cheque_run = ChequeRun.from_csv_string csv_string_3_cheques, @user
      csv_string_1_cheque = <<CSV_DATA
Date,Chq No,Name,Description,Amount
4-Nov-2011,788981,IRAS,201012345D,-1160
CSV_DATA
      wrong_user = User.create(email: "email3@example.com", password: "foobar", first_name: "cris", last_name: 'doe')
      ChequeRun.from_csv_string csv_string_1_cheque, wrong_user

      visit cheque_runs_path
      page.should have_css("table#cheque_runs tr", :count => 1)

      within "table#cheque_runs tr" do
        page.should have_css("td.count", :text => "3")
      end

    end
  end

  describe '/cheque_runs/new' do
    it "has a form that accepts and parses a cheque csv, and creates a ChequeRun with the current user as the owner" do
      visit new_cheque_run_path
      attach_file('Cheque File', Rails.root.join('spec', 'fixtures', 'cheques.csv'))

      click_button 'Submit'
      cheque_run = ChequeRun.last
      cheque_run.owner.should == @user

      current_path.should == cheque_run_path(cheque_run)
      page.should have_css("table#cheque_run tr", :count => cheque_run.cheques.size)
    end

  end

  describe '/cheque_runs/:id' do
    let(:cheque_run) do
      user = User.create!(:email => "email2@example.com", :password => "foobar", :first_name => "Don", :last_name => "Larsen")
      ChequeRun.from_csv_file Rails.root.join('spec', 'fixtures', 'cheques.csv'), user
    end

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

    it "has the user name of the person who created the cheque run" do
      page.should have_css(".cheque_run_owner", :text => "Don Larsen")
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
