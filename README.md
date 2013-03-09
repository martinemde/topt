# ThorOptions

A replacement for Ruby's OptionParser (optparse).

Provides extended options parsing, compared to optparse, using [Thor](https://github.com/wycats/thor)'s
options parsing system.

## About

This is still a very fresh extraction. I haven't created any specs yet, so use with caution.

Open an issue if you want to use this but you're scared.

## Example

See the examples directory from examples.

    class Command
      extend ThorOptions

      option :verbose, type: :boolean, aliases: %w[-v], :default => false, desc: "Be noisy"
      argument :filename

      def initialize(given_args=ARGV)
        @arguments, @options, @extras = self.class.parse_options!(given_args)
      rescue ThorOptions::Error => e
        puts e.message
        puts "Usage: command [--verbose] filename"
        exit 1
      end

      def call
        filename = @arguments[:filename]
        puts "Opening file #{filename}" if @options[:verbose]

        File.open(filename) do |f|
          f.each_line do |line|
            puts "outputting line #{line}" if @options[:verbose]
            puts line
          end
        end

        puts "Done" if @options[:verbose]
      end
    end

    Command.new(ARGV).call

## Credit

A substantial portion of this code is extracted directly from [Thor](https://github.com/wycats/thor)
by Yehuda Katz, José Valim, and more.
