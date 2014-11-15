class Hat < ActiveRecord::Base
  belongs_to :user
  belongs_to :granted_by_user,
    :class_name => "User"

  validates :user, :presence => true
  validates :granted_by_user, :presence => true

  after_create :log_moderation

  def to_html_label
    h = "<span class=\"hat\" title=\"Granted by " <<
      "#{self.granted_by_user.username} on " <<
      "#{self.created_at.strftime("%Y-%m-%d")}\">" <<
      "<span class=\"crown\">"

    if self.link.present?
      h << "<a href=\"#{self.link}\" target=\"_blank\">"
    end

    h << self.hat

    if self.link.present?
      h << "</a>"
    end

    h << "</span></span>"

    h.html_safe
  end

  def log_moderation
    m = Moderation.new
    m.created_at = self.created_at
    m.user_id = self.user_id
    m.moderator_user_id = self.granted_by_user_id
    m.action = "Granted hat \"#{self.hat}\"" + (self.link.present? ?
      " (#{self.link})" : "")
    m.save
  end
end
