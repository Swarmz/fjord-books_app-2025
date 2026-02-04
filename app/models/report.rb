# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  after_save :sync_sent_mentions

  has_many :received_mentions, class_name: 'ReportMention', foreign_key: :mentioned_report_id, inverse_of: :mentioned_report, dependent: :destroy
  # reports that mention this report
  has_many :mentioned_reports, through: :received_mentions, source: :mentioning_report

  has_many :sent_mentions, class_name: 'ReportMention', foreign_key: :mentioning_report_id, inverse_of: :mentioning_report, dependent: :destroy
  # reports this report mentions
  has_many :mentioning_reports, through: :sent_mentions, source: :mentioned_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def sync_sent_mentions
    mentioned_report_ids = content.to_s.scan(%r{/reports/(\d+)}).flatten.map(&:to_i).uniq
    self.mentioning_report_ids = mentioned_report_ids - [id] # prevent self-reference
  end
end
