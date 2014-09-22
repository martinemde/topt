require 'topt/arguments'
require 'topt/argument'
require 'topt/options'
require 'topt/option'

module Topt
  class Parser
    attr_reader :options
    attr_reader :arguments

    # Create a parser for parsing ARGV input into options.
    #
    def initialize
      @options = {}
      @arguments = []
      yield self if block_given?
    end

    # Adds an option to the set of method options. If :for is given as option,
    # it allows you to change the options from a previous defined task.
    #
    #   parser.option :foo => :bar
    #
    # ==== Parameters
    # name<Symbol>:: The name of the argument.
    # options<Hash>:: Described below.
    #
    # ==== Options
    # :desc     - Description for the argument.
    # :required - If the argument is required or not.
    # :default  - Default value for this argument. It cannot be required and have default values.
    # :aliases  - Aliases for this option.
    # :type     - The type of the argument, can be :string, :hash, :array, :numeric or :boolean.
    # :banner   - String to show on usage notes.
    # :hide     - If you want to hide this option from the help.
    #
    def option(name, opts)
      @options[name] = Topt::Option.new(name, opts)
    end

    # Adds an argument to the class and creates an attr_accessor for it.
    #
    # Arguments are different from options in several aspects. The first one
    # is how they are parsed from the command line, arguments are retrieved
    # from position:
    #
    #   thor task NAME
    #
    # Instead of:
    #
    #   thor task --name=NAME
    #
    # Besides, arguments are used inside your code as an accessor (self.argument),
    # while options are all kept in a hash (self.options).
    #
    # Finally, arguments cannot have type :default or :boolean but can be
    # optional (supplying :optional => :true or :required => false), although
    # you cannot have a required argument after a non-required argument. If you
    # try it, an error is raised.
    #
    # ==== Parameters
    # name<Symbol>:: The name of the argument.
    # options<Hash>:: Described below.
    #
    # ==== Options
    # :desc     - Description for the argument.
    # :required - If the argument is required or not.
    # :optional - If the argument is optional or not.
    # :type     - The type of the argument, can be :string, :hash, :array, :numeric.
    # :default  - Default value for this argument. It cannot be required and have default values.
    # :banner   - String to show on usage notes.
    #
    # ==== Errors
    # ArgumentError:: Raised if you supply a required argument after a non required one.
    #
    def argument(name, opts={})
      required = if opts.key?(:optional)
        !opts[:optional]
      elsif opts.key?(:required)
        opts[:required]
      else
        opts[:default].nil?
      end

      remove_argument name

      if required
        @arguments.each do |argument|
          next if argument.required?
          raise ArgumentError,
            "You cannot have #{name.to_s.inspect} as required argument after " \
            "the non-required argument #{argument.human_name.inspect}."
        end
      end

      opts[:required] = required

      @arguments << Topt::Argument.new(name, opts)
    end

    # Removes a previous defined argument.
    #
    # ==== Parameters
    # names<Array>:: Arguments to be removed
    #
    # ==== Examples
    #
    #   parser.remove_argument :foo
    #   parser.remove_argument :foo, :bar, :baz
    #
    def remove_argument(*names)
      names.each do |name|
        @arguments.delete_if { |a| a.name == name.to_s }
      end
    end

    # Parse the given argv-style arguments and return options, arguments,
    # and any remaining unnamed arguments
    def parse(given_args=ARGV, defaults_hash = {})
      # split inbound arguments at the first argument
      # that looks like an option (starts with - or --).
      argv_args, argv_switches = Topt::Options.split(given_args.dup)

      # Let Thor::Options parse the options first, so it can remove
      # declared options from the array. This will leave us with
      # a list of arguments that weren't declared.
      parsed_options, remaining = parse_options(argv_switches, defaults_hash)

      # Add the remaining arguments from the options parser to the
      # arguments from argv_args. Then remove any positional
      # arguments declared using #argument. This will leave us with
      # the remaining positional arguments.
      to_parse = argv_args + remaining
      parsed_arguments, parsed_remaining = parse_arguments(to_parse)

      [parsed_options, parsed_arguments, parsed_remaining]
    end

    # Parse option switches array into options and remaining non-option
    # positional arguments.
    def parse_options(argv_switches, defaults_hash)
      options_parser = Topt::Options.new(@options, defaults_hash)
      [options_parser.parse(argv_switches), options_parser.remaining]
    end

    # Parse declared arguments from the given argument array, returning
    # a hash of argument name and values, and an array of remaining args.
    def parse_arguments(to_parse)
      args_parser = Topt::Arguments.new(@arguments)
      [args_parser.parse(to_parse), args_parser.remaining]
    end
  end
end
