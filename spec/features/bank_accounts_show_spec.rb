require 'rails_helper'

feature 'Bank Accounts Show', js: true do
  login_js
  before(:each) do
    FactoryGirl.create(:bank_account)
    visit('/bank_accounts/1')
  end

  scenario 'show a current balance' do
    expect(page).to have_content(@bank_account.amount)
  end
end
