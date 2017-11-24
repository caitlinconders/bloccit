class User < ApplicationRecord

  before_save :format_name

  before_save { self.email = email.downcase if email.present? }

  # we use Ruby's validates function to ensure that name is present and has a maximum and minimum length.
  validates :name, length: { minimum: 1, maximum: 100 }, presence: true

  # we validate password with two separate validations
  validates :password, presence: true, length: { minimum: 6 }, if: "password_digest.nil?"
  validates :password, length: { minimum: 6 }, allow_blank: true

  # we validate that email is present, unique, case insensitive, has a minimum length, has a maximum length, and that it is a properly formatted email address.
  validates :email,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 254 }

  # adds methods to set and authenticate against a BCrypt password. This mechanism requires you to have a password_digest attribute
  has_secure_password


      def format_name
        if name
          name_array = []
          name.split.each do |n|
              name_array << n.capitalize
          end
          self.name = name_array.join(' ')
        end
      end

end
