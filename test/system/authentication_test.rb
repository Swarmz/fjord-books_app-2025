# frozen_string_literal: true

require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'user can sign in' do
    visit new_user_session_path
    fill_in 'Eメール', with: 'bob@example.com'
    fill_in 'パスワード', with: 'Password!'
    click_button 'ログイン'
    assert_text 'ログインしました。'
    assert_selector 'h1', text: '本の一覧'
  end

  test 'redirects guest to login page' do
    visit root_url
    assert_text 'ログインもしくはアカウント登録してください。'
  end
end
