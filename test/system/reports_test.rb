# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    sign_in users(:bob)
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'Bobs Report'
    fill_in '内容', with: 'Hi, my name is Bob.'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text 'Bobs Report'
  end

  test 'should update report' do
    report = reports(:one)

    visit report_url(report)
    click_on 'この日報を編集', match: :first

    fill_in 'タイトル', with: 'Updated Title'
    fill_in '内容', with: 'Updated Content'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text 'Updated Title'
    assert_text 'Updated Content'
  end

  test 'should destroy report' do
    report = reports(:one)

    visit report_url(report)
    click_on 'この日報を削除', match: :first

    assert_text '日報が削除されました。'
  end
end
