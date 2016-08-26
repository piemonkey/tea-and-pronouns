class User < ApplicationRecord
  has_many :group_memberships
  has_many :groups, through: :group_memberships

  before_save { self.email = email.downcase }

  has_secure_password
  has_secure_token

  VALID_EMAIL_REGEX = /.+\@.+\..+/

  validates :email, presence: true, 
                    length: { maximum: 255 }, 
                    format: { with: VALID_EMAIL_REGEX }, 
                    uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 8 },
                       allow_nil: true

  validates :name, presence: true

  def group_invites(user)
    user.group_memberships.includes(:group)
    .where(accepted: false)
    .map do |group_membership|
      group_membership.group.name
    end
  end
end
