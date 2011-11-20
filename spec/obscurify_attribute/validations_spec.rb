require 'spec_helper'

describe "ObscurifyAttribute::Validations" do
  it "should respond to obscurify" do
    ObscurifyAttributeItem.respond_to?(:obscurify).should be_true
  end

  it "should only allow :message as a valid key for the options hash" do
    lambda {
      ObscurifyAttributeItem.obscurify :first_name, :name, :messages => "blah"
    }.should raise_error(ArgumentError, "Unknown key: messages")
  end

  it "should not allow only a single attribute name (leaving the target name blank)" do
    lambda {
      ObscurifyAttributeItem.obscurify :first_name
    }.should raise_error(ArgumentError, "Should specify a second (target) attribute name")
  end

  it "should discard blank attribute names" do
    lambda {
      ObscurifyAttributeItem.obscurify :first_name, "", "  "
    }.should raise_error(ArgumentError, "Should specify a second (target) attribute name")
  end

  it "should allow a single attribute to be obscured" do
    ObscurifyAttributeItem.obscurify :first_name, :name

    obs = ObscurifyAttributeItem.new
    obs.should_not be_valid
    obs.errors[:first_name].should == []
    obs.errors[:name].should == ["can't be blank"]
  end

  it "should allow multiple attributes to be obscured to different targets" do
    ObscurifyAttributeItem.obscurify :first_name, :fName
    ObscurifyAttributeItem.obscurify :last_name, :lName

    obs = ObscurifyAttributeItem.new
    obs.should_not be_valid
    obs.errors[:first_name].should == []
    obs.errors[:fName].should == ["can't be blank"]
    obs.errors[:last_name].should == []
    obs.errors[:lName].should == ["can't be blank"]
  end

  it "should allow multiple attributes to be obscured to the same target" do
    ObscurifyAttributeItem.obscurify :first_name, :name
    ObscurifyAttributeItem.obscurify :last_name, :name

    obs = ObscurifyAttributeItem.new
    obs.should_not be_valid
    obs.errors[:first_name].should == []
    obs.errors[:last_name].should == []
    obs.errors[:name].should == ["can't be blank"]
  end

  it "should uniq the errors on the target attribute" do
    ObscurifyAttributeItem.obscurify :first_name, :last_name, :name

    obs = ObscurifyAttributeItem.new
    obs.should_not be_valid
    obs.errors[:first_name].should == []
    obs.errors[:last_name].should == []
    obs.errors[:name].should == ["can't be blank"]
  end

  it "should handle a custom message" do
    ObscurifyAttributeItem.obscurify :first_name, :fName, :message => "foo"
    ObscurifyAttributeItem.obscurify :last_name, :lName, :message => "bar"

    obs = ObscurifyAttributeItem.new
    obs.should_not be_valid
    obs.errors[:first_name].should == []
    obs.errors[:fName].should == ["foo"]
    obs.errors[:last_name].should == []
    obs.errors[:lName].should == ["bar"]
  end
end
