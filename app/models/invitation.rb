class Invitation < ActiveRecord::Base
# always name the associations like the schema
  belongs_to :send_user, class_name: 'User'
  belongs_to :accept_user, class_name: 'User'

  validates :send_user_id, :accept_user_id, :date_cuisine,  :date, presence: true
  validate :same_date, on: :update
  validate :create_date, on: :create

  def same_date
    user = self.send_user
    a = user.sent_invitations
    b = user.accepted_invitations

    inv_arr = a + b

    inv_arr.each do |inv|
      if self.send_user_id == inv.send_user_id && self.accept_user_id == inv.accept_user_id && inv.pending == false
        errors.add(:send_user, "you've already matched!")
      # elsif self.send_user_id == inv.send_user_id && self.accept_user_id == inv.accept_user_id
      #   errors.add(:send_user, "you've sent an invitation already")
      end
    end
  end

  def create_date
    user = self.send_user
    a = user.sent_invitations
    b = user.accepted_invitations

    inv_arr = a + b


    inv_arr.each do |inv|
      if self.send_user_id == inv.send_user_id && self.accept_user_id == inv.accept_user_id
        errors.add(:send_user, "you've already sent a request to that person")
      # elsif self.send_user_id == inv.send_user_id && self.accept_user_id == inv.accept_user_id
      #   errors.add(:send_user, "you've sent an invitation already")
      end
    end
  end
end
