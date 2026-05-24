# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @mentioning_report = reports(:mentioning_report)
    @mentioned_report = reports(:mentioned_report)
  end

  test 'can edit their own report' do
    user = users(:bob)
    assert_equal true, reports(:bobs_report).editable?(user)
  end

  test 'cannot edit another users reports' do
    user = users(:alice)
    assert_equal false, reports(:bobs_report).editable?(user)
  end

  test 'created_on returns date only' do
    time = Time.zone.local(2015, 8, 1, 14, 35, 0)
    report = Report.new(created_at: time)
    assert_equal Date.new(2015, 8, 1), report.created_on
  end

  test 'mentioned report is saved as a mention' do
    @mentioning_report.update!(
      content: "I found a useful report here: http://localhost:3000/reports/#{@mentioned_report.id}"
    )
    assert_includes @mentioning_report.mentioning_reports, @mentioned_report
  end

  test 'report does not create mention for self' do
    @mentioning_report.update!(
      content: "http://localhost:3000/reports/#{@mentioning_report.id}"
    )
    assert_not_includes @mentioning_report.mentioning_reports, @mentioning_report
  end

  test 'mention is removed from report' do
    @mentioning_report.update!(
      content: "http://localhost:3000/reports/#{@mentioned_report.id}"
    )
    assert_includes @mentioning_report.mentioning_reports, @mentioned_report

    @mentioning_report.update!(
      content: 'Mention removed.'
    )
    updated_mentions = @mentioning_report.mentioning_reports.reload
    assert_not_includes updated_mentions, @mentioned_report
  end

  test 'replaces old mentions with new ones' do
    @mentioning_report.update!(
      content: "I found a useful report here: http://localhost:3000/reports/#{@mentioned_report.id}"
    )
    assert_includes @mentioning_report.mentioning_reports, @mentioned_report

    @mentioning_report.update!(content: "http://localhost:3000/reports/#{reports(:alices_report).id}")
    updated_mentions = @mentioning_report.mentioning_reports.reload

    assert_includes updated_mentions, reports(:alices_report)
    assert_not_includes updated_mentions, @mentioned_report
  end
end
