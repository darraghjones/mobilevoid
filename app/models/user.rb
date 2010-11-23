class User < ActiveRecord::Base
  
  attr_accessible :mobile, :password, :password_confirmation
  attr_accessor :password

  validates :mobile, :presence => true, 
                     :format => { :with => /\d{6,14}/ },
                     :uniqueness => true
  
  #automatically create the virtual attribute 'password_confirmation'.
  validates :password, :presence     => true,
                       :confirmation => true,
                       :length       => { :within => 6..40 }

  before_save :encrypt_password, :create_confirm_code

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
    encrypted_password == encrypt(submitted_password)
  end

  def self.authenticate(mobile, submitted_password)
    user = find_by_mobile(mobile)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.confirm!(mobile, submitted_confirm_code)
    user = find_by_mobile(mobile)
    if user && user.confirm_code == submitted_confirm_code
      user.update_attribute(:confirmed, true)
    end
    user
  end

  private

    def create_confirm_code
        self.confirm_code = (1000 + rand(8999)).to_s if new_record?
    end

    def encrypt_password
      self.salt = make_salt if new_record?
      self.encrypted_password = encrypt(password)
    end

    def encrypt(string)
      secure_hash("#{salt}--#{string}")
    end

    def make_salt
      secure_hash("#{Time.now.utc}--#{password}")
    end

    def secure_hash(string)
      Digest::SHA2.hexdigest(string)
    end

end
