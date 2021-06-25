class Article < ApplicationRecord
  validates :title, presence: true

  def self.search_by(query)
    if !query.blank?
      where ['lower(articles.title) like :search', { search: "%#{query.downcase.strip}%" }]
    else
      all
    end
  end

  def self.logs_duration(from, to)
    if !from.blank? && !to.blank?
      where(:created_at => from..to)
    else
      all
    end
  end

end
