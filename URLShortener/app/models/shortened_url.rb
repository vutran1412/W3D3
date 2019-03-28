# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  long_url   :string           not null
#  short_url  :string
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ApplicationRecord
  validates :long_url, presence: true, uniqueness: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User
    
  has_many :visits,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :Visit

  has_many :visitors,
    Proc.new { distinct},
    through: :visits,
    source: :visitor

  def self.create!(user, long_url)
    ShortenedUrl.create(long_url: long_url, short_url: ShortenedUrl.random_code, user_id: user.id)
  end

  def self.random_code
    url_code = SecureRandom.urlsafe_base64
    while ShortenedUrl.exists?(:short_url => url_code)
      url_code = SecureRandom.urlsafe_base64
    end
    url_code
  end

  def num_clicks
    visitors.count
  end

  def num_uniques
    visitors.count
  end

  def num_recent_uniques
    visitors.where("visits.created_at > ?", 10.minutes.ago).uniq.count
  end
end
