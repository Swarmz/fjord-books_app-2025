# frozen_string_literal: true

class ReportMention < ApplicationRecord
  belongs_to :mentioning_report, class_name: 'Report', inverse_of: :sent_mentions
  belongs_to :mentioned_report, class_name: 'Report', inverse_of: :received_mentions

  validates :mentioned_report_id, uniqueness: { scope: :mentioning_report_id }
end
