require 'spec_helper'

describe User do

  before (:each) do
    @attr = { 
              :name                  => "user", 
              :email                 => "example@user.com",
              :password              => "foobar",
              :password_confirmation => "foobar"
  }
  end

  it "should create a new instance given valid attributes" do
    User.create!(@attr)
  end

  it "should require a name" do
    no_name_user = User.new(@attr.merge(:name => ""))
    no_name_user.should_not be_valid
  end

  it "should require an email address" do
    no_name_user = User.new(@attr.merge(:email => ""))
    no_name_user.should_not be_valid
  end

  it "should reject names that are too long" do
    long_name = "a" * 51
    long_name_user = User.new(@attr.merge(:name => long_name))
    long_name_user.should_not be_valid
  end

  it "should accept valid email addresses" do
    addresses = %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp]
    addresses.each do |address|
    valid_email_user = User.new(@attr.merge(:email => address))
    valid_email_user.should be_valid
    end
  end

  it "should reject invalid email addresses" do
   addresses = %w[user@foo,com user_at_foo.org example.user@foo.]
   addresses.each do |address|
   invalid_email_user = User.new(@attr.merge(:email => address))
   invalid_email_user.should_not be_valid
   end
 end

  it "should reject duplicate email addresses" do
    # Put a user with given email address into the database
    User.create!(@attr)
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end



  it "should reject email addresses identical up to case" do
    upcased_email = @attr[:email].upcase
    User.create!(@attr.merge(:email => upcased_email))
    user_with_duplicate_email = User.new(@attr)
    user_with_duplicate_email.should_not be_valid
  end

describe  "password validation" do


    it "should require a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).
      should_not be_valid
    end

    it "should require a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).
      should_not be_valid
    end

    it "should reject short password" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "should reject long password" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
  end

describe "password encryption" do
  
  before(:each) do
    @user = User.create!(@attr)
  end

  it "should have an encrypted password attribute" do
    @user.should respond_to(:encrypted_password)
    end
  
  it "should set the encrypted password" do
    @user.encrypted_password.should_not be_blank
    end
  
describe "has_password? method" do

  before(:each) do
    DatabaseCleaner.clean
    @user = User.create!(@attr) 
  end 

  it "should have a salt" do
    @user.should respond_to(:salt)    
  end
  
  it "should be true if the password match" do
    @user.password.should equal(@attr[:password])
  end

  it "should be false if the password don't match" do
    @user.password.should_not equal("invalid")
      end
    end

describe "authenticate method" do

  before(:each) do
    DatabaseCleaner.clean
    @user = User.create!(@attr) 
  end 

  it "should exist" do
    User.should respond_to(:authenticate)
  end

  it "should return nil for an email address with no user" do
    nonexistent_user = User.authenticate("bar@foo.com", @attr[:password])
    nonexistent_user.should be_nil
   end

  it "should return nil on email/password mismatch" do
    wrong_password_user = User.authenticate(@attr[:email], "wrongpass")
    wrong_password_user.should be_nil
  end

      it "should return the user on email/password match" do
        User.authenticate(@attr[:email], @attr[:password]).should == @user
      end
    end
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#
