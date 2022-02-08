# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  attr_accessor :skip_password_validation

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook github google_oauth2]
  has_many :orders, dependent: :nullify
  has_many :addresses, dependent: :nullify

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider,
          uid: provider_data.uid).first_or_create do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
    end
  end

  protected

  def password_required?
    return false if skip_password_validation

    super
  end
end
