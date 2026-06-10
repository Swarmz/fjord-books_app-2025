# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'return name when name exists' do
    user = User.new(name: 'Bob', email: 'bob@example.com')
    assert_equal 'Bob', user.name_or_email
  end

  test 'return email when name is nil' do
    user = User.new(name: nil, email: 'bob@example.com')
    assert_equal 'bob@example.com', user.name_or_email
  end
end
