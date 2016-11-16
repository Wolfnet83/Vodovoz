class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable,:database_authenticatable,
         :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  # attr_accessible :username, :email, :password, :password_confirmation, :remember_me

  def email_required?
    false
  end

end
