class UserAuthenticator
  # @param user [User]
  def initialize(user)
    @user = user
  end

  # Performs a login (with all its side-effects) given an username or an email and a password.
  #
  # @param username_or_email [String] the username or email to find the user
  # @param password [String]
  # @return [User, nil] the user object if the login was successful or nil if it failed.
  def self.login(username_or_email, password)
    user = User.find_by_username_or_email(username_or_email)
    new(user).login(password)
  end

  # Given an user and a password, checks if the password is correct for that user.
  #
  # @param user [User]
  # @param password [String]
  # @return [Boolean] true if the authentication was successful, false if not.
  def self.authenticate(user, password)
    new(user).authenticate(password)
  end

  # Given a password, performs a login (with all its side-effects)
  # for @user (instance variable set on initialize)
  #
  # @param password [String]
  # @return [User, nil] the user object if the login was successful or nil if it failed.
  def login(password)
    return nil if @user.blank?

    if authenticate(password)
      @user.unlock_account!
      return @user
    else
      @user.add_failed_login_attempt!
      return nil
    end
  end

  # Given a password, checks if the password is correct
  # for @user (instance variable set on initialize)
  #
  # @param password [String]
  # @return [Boolean] true if the authentication was successful, false if not.
  def authenticate(password)
    return false if @user.blank?

    salt = @user.salt
    hash = @user.crypted_password

    salt && password && (Digest::SHA1.hexdigest(salt + password) == hash)
  end
end
