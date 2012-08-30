require 'spec_helper'

describe Client do
  before(:each) do
    @attr = { :company => "Example Company", :phone_number => "023154565", :contact => ''}
  end

  it "should create new client using valid attributes" do
    Client.create!(@attr)
  end

  it "shouldn't work without company name" do
    no_company_name = Client.new(@attr.merge(:company => ""))
    no_company_name.should_not be_valid
  end

  it "company name has to be more than 3 symbols" do
    short_company_name = Client.new(@attr.merge(:company =>"te"))
    short_company_name.should_not be_valid
  end
  
  it "shouldn't work without phone number" do
    no_phone_number = Client.new(@attr.merge(:phone_number => ""))
    no_phone_number.should_not be_valid
  end

  it "phone number has to be in valid format" do
    bad_number_format = Client.new(@attr.merge(:phone_number => "0234ww000"))
    bad_number_format.should_not be_valid
  end
end
