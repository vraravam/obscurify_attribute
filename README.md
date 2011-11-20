# Obscurify Attribute

Obscures all sensitive attributes from showing up in the errors object for Active Records/Resources

## Install

Add the following line to your Gemfile

    gem 'obscurify_attribute'

## Usage

Add the following line into your ActiveRecord (or ActiveResource) model:

    class Payment < ActiveRecord::Base
        # if credit_card is one of the attributes, but it should not be shown to the user...
        obscurify :credit_card, :payment_information, :message => "foo bar"
    end

:message is optional. It defaults to the same messages that were reported for the original attribute.
If specified, the new message will overwrite the reported array. All messages are uniqued to avoid duplicates
(since you can specify the same target attribute name for multiple source attributes)!


ObscurifyAttribute will iterate over the errors object and mask sensitive fields with a different
(user-specified) name so that they dont show up in the UI.

## Known issues

## Contribute & Dev environment

Usual fork & pull request.
