# frozen_string_literal: true
#
# \Module \Base64 provides methods for:
#
# - Encoding a binary string (containing non-ASCII characters)
#   as a string of printable ASCII characters.
# - Decoding such an encoded string.
#
# The encoded string consists only of characters from a 64-character set
# that includes:
#
# - <tt>('A'..'Z')</tt>.
# - <tt>('a'..'z')</tt>.
# - <tt>('0'..'9')</tt>.
# - Either:
#   - <tt>%w[+ /]</tt>:
#     {RFC 2045-compliant}[https://datatracker.ietf.org/doc/html/rfc2045];
#     _not_ suitable for URLs.
#   - <tt>%w[- _]</tt>:
#     {RFC 4648-compliant}[https://datatracker.ietf.org/doc/html/rfc4648];
#     suitable for URLs.
#
# \Base64 is commonly used in contexts where binary data
# is not allowed or supported:
#
# - Images in HTML or CSS files, or in URLs.
# - Email attachments.
#
# A \Base64-encoded string is about one-third larger that its source.
# See the {Wikipedia article}[https://en.wikipedia.org/wiki/Base64]
# for more information.
#
# Examples on this page assume that the including program has executed:
#
#   require 'base64'
#
module Base64
  module_function

  # Returns the Base64-encoded version of +bin+.
  # This method complies with RFC 2045.
  # Line feeds are added to every 60 encoded characters.
  #
  #    require 'base64'
  #    Base64.encode64("Now is the time for all good coders\nto learn Ruby")
  #
  # <i>Generates:</i>
  #
  #    Tm93IGlzIHRoZSB0aW1lIGZvciBhbGwgZ29vZCBjb2RlcnMKdG8gbGVhcm4g
  #    UnVieQ==
  def encode64(bin)
    [bin].pack("m")
  end

  # Returns the Base64-decoded version of +str+.
  # This method complies with RFC 2045.
  # Characters outside the base alphabet are ignored.
  #
  #   require 'base64'
  #   str = 'VGhpcyBpcyBsaW5lIG9uZQpUaGlzIG' +
  #         'lzIGxpbmUgdHdvClRoaXMgaXMgbGlu' +
  #         'ZSB0aHJlZQpBbmQgc28gb24uLi4K'
  #   puts Base64.decode64(str)
  #
  # <i>Generates:</i>
  #
  #    This is line one
  #    This is line two
  #    This is line three
  #    And so on...
  def decode64(str)
    str.unpack1("m")
  end

  # Returns the Base64-encoded version of +bin+.
  # This method complies with RFC 4648.
  # No line feeds are added.
  def strict_encode64(bin)
    [bin].pack("m0")
  end

  # Returns the Base64-decoded version of +str+.
  # This method complies with RFC 4648.
  # ArgumentError is raised if +str+ is incorrectly padded or contains
  # non-alphabet characters.  Note that CR or LF are also rejected.
  def strict_decode64(str)
    str.unpack1("m0")
  end

  # Returns the Base64-encoded version of +bin+.
  # This method complies with ``Base 64 Encoding with URL and Filename Safe
  # Alphabet'' in RFC 4648.
  # The alphabet uses '-' instead of '+' and '_' instead of '/'.
  # Note that the result can still contain '='.
  # You can remove the padding by setting +padding+ as false.
  def urlsafe_encode64(bin, padding: true)
    str = strict_encode64(bin)
    str.chomp!("==") or str.chomp!("=") unless padding
    str.tr!("+/", "-_")
    str
  end

  # Returns the Base64-decoded version of +str+.
  # This method complies with ``Base 64 Encoding with URL and Filename Safe
  # Alphabet'' in RFC 4648.
  # The alphabet uses '-' instead of '+' and '_' instead of '/'.
  #
  # The padding character is optional.
  # This method accepts both correctly-padded and unpadded input.
  # Note that it still rejects incorrectly-padded input.
  def urlsafe_decode64(str)
    # NOTE: RFC 4648 does say nothing about unpadded input, but says that
    # "the excess pad characters MAY also be ignored", so it is inferred that
    # unpadded input is also acceptable.
    if !str.end_with?("=") && str.length % 4 != 0
      str = str.ljust((str.length + 3) & ~3, "=")
      str.tr!("-_", "+/")
    else
      str = str.tr("-_", "+/")
    end
    strict_decode64(str)
  end
end
