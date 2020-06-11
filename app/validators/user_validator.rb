class UserValidator < ActiveModel::Validator
  def validate(user)
    unless user.email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      user.errors[:email] << 'is invalid'
      return
    end

    # get_info_from_ldap always returns nil in test mode
    if !Rails.env.test?
      if user.get_info_from_ldap.nil?
        user.errors[:email] << " does not belong to the university or does not exist"
      end
    end
  end
end
