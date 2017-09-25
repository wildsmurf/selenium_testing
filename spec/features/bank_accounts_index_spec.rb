require 'rails_helper'

feature 'Bank Accounts Index', js: true do
  login_js

  context 'with bank accounts' do
    before(:each) do
      @account_count = 5
      FactoryGirl.create_list(:bank_account, @account_count, user: @user)
      visit bank_accounts_path
    end

    scenario 'shows each bank account' do
      expect(all('.bank-account').count).to eq(@account_count)
      @user.bank_accounts.each do |account|
        expect(page).to have_content(account.institution)
        expect(page).to have_content(account.description)
      end
    end

    scenario 'deletes a bank account if confirmed' do
      accept_confirm do
        all('.delete-account').first.click
      end
      expect(page).to have_selector('.bank-account', count: @account_count - 1)
    end

    scenario 'does not delete a bank account if not confirmed' do
      dismiss_confirm do
        all('.delete-account').first.click
      end
      expect(page).to have_selector('.bank-account', count: @account_count)
    end

    scenario 'link to the show link is on the page' do
      expect(page).to have_selector('.show-account', count: @account_count)
    end
  end

  context 'without bank accounts' do
    before(:each) do
      # Capybara DSL - docs
      visit bank_accounts_path
    end

    scenario 'correct no bank account message' do
      expect(page).to have_content('No Bank Accounts, Please Create One!')
    end

    scenario 'correct header content' do
      expect(page).to have_content('All Of My Monies')
    end

    scenario 'link to create new bank account exsists' do
      expect(page).to have_selector('#new-bank-account')
    end

  end
end
