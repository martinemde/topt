require 'thor_options/parser'

# Extend your class with this module to add Thor-like options methods.
#
# This currently does not do any magical method based things, so you'll
# need to do one command per class or instantiate the parser directly.
#
# Instantiating directly can really make your command easy to understand,
# since there is very little magic going on at that point.
module ThorOptions
  def options_parser
    @parser ||= Parser.new
  end

  def options
    options_parser.options
  end
  alias_method :method_options, :options # Thor compatibility

  def option(name, options)
    options_parser.option(name, options)
  end
  alias_method :method_option, :option # Thor compatibility

  def arguments
    options_parser.arguments
  end

  def argument(name, options={})
    attr_accessor name
    options_parser.argument(name, options)
  end

  def remove_argument(*names)
    options_parser.remove_argument(*nname)
  end

  def parse_options!(given_args=ARGV, defaults_hash = {})
    options_parser.parse(given_args, defaults_hash)
  end
end
