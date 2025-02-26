class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, :email, :start_date, :location, :contract_type, presence: true
  validates :email, uniqueness: { case_sensitive: false },
                   format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i,
                           message: "must be a valid email address" }
  validates :password, presence: true, length: { minimum: 6 }


  def seniority
    return 0 unless start_date

    ((Time.current - start_date.to_time) / 1.year).floor
  end
end
