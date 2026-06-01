# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'can edit their own report' do
    user = users(:bob)
    report = Report.new(
      user: user,
      title: 'Bobs Report',
      content: 'Today was a good day'
    )

    assert report.editable?(user)
  end

  test 'cannot edit another users reports' do
    user = users(:alice)
    another_user = users(:bob)

    report = Report.new(
      user: user,
      title: 'Alices Report',
      content: 'Today was a bad day'
    )

    assert_not report.editable?(another_user)
  end

  test 'created_on returns date only' do
    time = Time.zone.local(2015, 8, 1, 14, 35, 0)
    report = Report.new(created_at: time)
    assert_equal Date.new(2015, 8, 1), report.created_on
  end

  test 'mentioned report is saved as a mention' do
    report = reports(:one)
    mentioned_report = reports(:two)

    report.update!(
      content: "I found a useful report here: http://localhost:3000/reports/#{mentioned_report.id}"
    )
    assert_includes report.mentioning_reports, mentioned_report
  end

  test 'report does not create mention for self' do
    report = reports(:one)

    report.update!(
      content: "http://localhost:3000/reports/#{report.id}"
    )
    assert_not_includes report.mentioning_reports, report
  end

  test 'mention is removed from report' do
    report = reports(:one)
    mentioned_report = reports(:two)

    report.update!(
      content: "http://localhost:3000/reports/#{mentioned_report.id}"
    )
    assert_includes report.mentioning_reports, mentioned_report

    report.update!(
      content: 'Mention removed.'
    )
    updated_mentions = report.mentioning_reports.reload
    assert_not_includes updated_mentions, mentioned_report
  end

  test 'replaces old mention with new mention' do
    report = reports(:one)
    mentioned_report = reports(:two)

    report.update!(
      content: "I found a useful report here: http://localhost:3000/reports/#{mentioned_report.id}"
    )
    assert_includes report.mentioning_reports, mentioned_report

    new_mention = reports(:three)
    report.update!(
      content: "http://localhost:3000/reports/#{new_mention.id}"
    )
    updated_mentions = report.mentioning_reports.reload

    assert_includes updated_mentions, new_mention
    assert_not_includes updated_mentions, mentioned_report
  end
end
