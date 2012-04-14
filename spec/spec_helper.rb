require 'simplecov'
SimpleCov.start { add_filter 'spec/' }

require 'mocha'
require 'space'
require 'ansi'

module Kernel
  def log(*)
  end
end

module Ansi
  def strip_ansi(string)
    string.gsub!(/\e\[[\d]+(;[\d]+)?m/, '')
    string.gsub!("\e[2J\e[0;0H", '')
  end
end

RSpec.configure do |config|
  config.include Ansi
  config.mock_framework = :mocha
end

module Kernel
  def capture_stdout
    out = StringIO.new
    $stdout = out
    yield
    return out.string
  ensure
    $stdout = STDOUT
  end
end
