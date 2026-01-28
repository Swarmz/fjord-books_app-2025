# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  after_save :sync_mentions_made

  has_many :mentions_received, class_name: 'ReportMention', foreign_key: :mentioned_report_id, inverse_of: :mentioned_report, dependent: :destroy
  # reports that mention this report
  has_many :mentioned_reports, through: :mentions_received, source: :mentioning_report

  has_many :mentions_made, class_name: 'ReportMention', foreign_key: :mentioning_report_id, inverse_of: :mentioning_report, dependent: :destroy
  # reports this report mentions
  has_many :mentioning_reports, through: :mentions_made, source: :mentioned_report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  private

  def mentioned_report_ids_from_content
    return [] if content.blank?

    content.scan(%r{/reports/(\d+)}).flatten.map(&:to_i).uniq - [id] # subtract own id to prevent self-reference
  end

  def sync_mentions_made
    # uses the association ID setter to diff and replace join rows
    self.mentioning_report_ids = mentioned_report_ids_from_content
  end
end
