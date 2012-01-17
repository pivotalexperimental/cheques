class User < ActiveRecord::Base

  belongs_to :organization
  has_many :cheque_runs, :foreign_key => "owner_id"
  validates :organization_id, presence: true

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  #devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable
  devise :database_authenticatable, :rememberable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :first_name, :last_name

  def full_name
    "#{first_name} #{last_name}"
  end
end
