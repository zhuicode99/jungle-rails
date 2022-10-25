require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#create user' do
    it 'ensures user is created when passwords match' do
      @user = User.new(first_name: "Jason", last_name: "Chen", email: "jason@mail.com", password: "password", password_confirmation: "password")
      @user.save
      expect(@user).to be_valid
    end

    it 'ensures user is not created when passwords do not match' do
      @user = User.new(first_name: "Jason", last_name: "Chen", email: "jason@mail.com", password: "passwrd", password_confirmation: "password")
      @user.save
      expect(@user).to_not be_valid
      expect(@user.errors.full_messages).to include("Password confirmation doesn't match Password")
    end

    it 'ensures email is unique to one user' do
      @user1 = User.new(first_name: "Jason", last_name: "Chen", email: "jason@mail.com", password: "password", password_confirmation: "password")
      @user1.save

      @user2 = User.new(first_name: "Jason", last_name: "Chong", email: "jason@mail.com", password: "password", password_confirmation: "password")
      @user2.save
      expect(@user1).to be_valid
      expect(@user2).to_not be_valid
      expect(@user2.errors.full_messages).to include("Email has already been taken")
    end

    it 'ensures user is not created when email is not passed' do
      @user = User.new(first_name: "Jason", last_name: "Chen", email: nil, password: "password", password_confirmation: "password")
      @user.save
      expect(@user.errors.full_messages).to include("Email can't be blank")
      expect(@user).to_not be_valid
    end

    it 'ensures user is not created when first name is not passed' do
      @user = User.new(first_name: nil, last_name: "Chen", email: "test@email.com", password: "password", password_confirmation: "password")
      @user.save
      expect(@user.errors.full_messages).to include("First name can't be blank")
      expect(@user).to_not be_valid
    end

    it 'ensures user is not created when last name is not passed' do
      @user = User.new(first_name: "Jason", last_name: nil, email: "test@email.com", password: "password", password_confirmation: "password")
      @user.save
      expect(@user.errors.full_messages).to include("Last name can't be blank")
      expect(@user).to_not be_valid
    end

    it 'ensures user is not created when password is less than 5 characters' do
      @user = User.new(first_name: "Jason", last_name: "Chen", email: "test@email.com", password: "pas", password_confirmation: "pas")
      @user.save
      # puts @user.errors.full_messages
      expect(@user.errors.full_messages).to include("Password is too short (minimum is 5 characters)")
      expect(@user).to_not be_valid
    end

  end

  describe '.authenticate_with_credentials' do
    # examples for this class method here
    it 'authenticates user with email and password' do
      @user = User.new(first_name: "Jason", last_name: "Chen", email: "jason@mail.com", password: "password", password_confirmation: "password")
      @user.save

      @verify = User.authenticate_with_credentials("jason@mail.com", "password")

      expect(@user).to eql(@verify)
    end

    it 'should not login user if the password is incorrect' do
      @user = User.new(first_name: "Jason", last_name: "Chen", email: "jason@mail.com", password: "password", password_confirmation: "password")
      @user.save

      @verify = User.authenticate_with_credentials("jason@mail.com", "wordpass")

      expect(@verify).to be_nil
    end

    it 'should not login user if the email is incorrect' do
      @user = User.new(first_name: "Jason", last_name: "Chen", email: "jason@mail.com", password: "password", password_confirmation: "password")
      @user.save

      @verify = User.authenticate_with_credentials("jasoon@mail.com", "password")

      expect(@verify).to be_nil
    end

    it 'authenticates user with email with surrounding whitespace' do
      @user = User.new(first_name: "Jason", last_name: "Chen", email: "jason@mail.com", password: "password", password_confirmation: "password")
      @user.save

      @verify = User.authenticate_with_credentials(" jason@mail.com ", "password")

      expect(@user).to eql(@verify)
    end
    

    it 'authenticates user with email without case sensetivity' do
      @user = User.new(first_name: "Jason", last_name: "Chen", email: "jason@mail.com", password: "password", password_confirmation: "password")
      @user.save

      @verify = User.authenticate_with_credentials("jASon@mail.com", "password")

      expect(@user).to eql(@verify)
    end

  end
end