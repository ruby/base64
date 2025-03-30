# frozen_string_literal: true

require 'base64'
require 'test/unit'
require 'rbs/unit_test'

class Base64SingletonTest < Test::Unit::TestCase
  include RBS::UnitTest::TypeAssertions

  library 'base64'
  testing "singleton(::Base64)"

  def test_decode64
    assert_send_type '(String) -> String',
                     Base64, :decode64, 'aGVsbG8gd29ybGQ='
  end

  def test_encode64
    assert_send_type '(String) -> String',
                     Base64, :encode64, 'hello world'
  end

  def test_strict_decode64
    assert_send_type '(String) -> String',
                     Base64, :strict_decode64, 'aGVsbG8gd29ybGQ='
  end

  def test_strict_encode64
    assert_send_type '(String) -> String',
                     Base64, :strict_encode64, 'hello world'
  end

  def test_urlsafe_decode64
    assert_send_type '(String) -> String',
                     Base64, :urlsafe_decode64, 'aGVsbG8gd29ybGQ='
  end

  def test_urlsafe_encode64
    assert_send_type '(String) -> String',
                     Base64, :urlsafe_encode64, 'hello world'
    assert_send_type '(String, padding: bool) -> String',
                     Base64, :urlsafe_encode64, '*', padding: false
  end
end
