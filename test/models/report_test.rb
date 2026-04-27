# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test 'can edit their own report' do
    user = users(:bob)
    assert_equal true, reports(:bobs_report).editable?(user)
  end

  test 'cannot edit another users reports' do
    user = users(:alice)
    assert_equal false, reports(:bobs_report).editable?(user)
  end

  test 'displayed report creation date returns creation date' do
    time = Time.zone.local(2015, 8, 1, 14, 35, 0)
    report = Report.new(created_at: time)
    assert_equal time.to_date, report.created_on
  end

  test 'mentioned report is saved as a mention' do
    report = reports(:mentioning_report)
    report.save!
    assert_includes report.mentioning_reports, reports(:mentioned_report)
  end

  test 'report does not create mention for self' do
    report = reports(:mentioning_report)
    report.update!(content: "http://localhost:3000/reports/#{report.id}")
    assert_not_includes report.mentioning_reports, report
  end

  test 'replaces old mentions with new ones' do
    report = reports(:mentioning_report)
    report.save!
    assert_includes report.mentioning_reports, reports(:mentioned_report)

    report.update!(content: 'http://localhost:3000/reports/1')
    updated_mentions = report.mentioning_reports.reload

    assert_includes updated_mentions, reports(:alices_report)
    assert_not_includes updated_mentions, reports(:mentioned_report)
  end
end
