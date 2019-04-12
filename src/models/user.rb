class User
  def change_password(password, new_password)
    if UserAuthenticator.authenticate(self, password)
      self.password = new_password
      save!
    else
      errors.add(:password, "is incorrect")
    end
  end

  def self.login(username_or_email, password)
    UserAuthenticator.login(username_or_email, password)
  end

  # @deprecated Please use {UserAuthenticator#authenticate} instead
  def password_correct(password)
    warn "[DEPRECATION] `password_correct` is deprecated.  Please use `UserAuthenticator#authenticate` instead."
    UserAuthenticator.authenticate(self, password)
  end
end
