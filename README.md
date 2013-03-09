# Thor Options

A replacement for OptionParser with extended parsing capabilites
originally available only with [Thor](https://github.com/wycats/thor),
a full stack command line library.

## Example

    # My own implementation of `cat` that takes less options.
    class Kat
      extend ThorOptions

      option :blank, type: :boolean, aliases: %w[-b],
        desc: "Number the non-blank output lines, starting at 1."

      option :number, type: :boolean, aliases: %w[-n],
        desc: "Number the output lines, starting at 1."

      argument :filename

      def initialize(given_args=ARGV)
        @arguments, @options, @extras = self.class.parse_options!(given_args)
      end

      def call
        content = File.read(@arguments[:filename])
        num = 1
        content.each_line do |line|
          if (@options[:number] || @options[:blank]) && !(@options[:blank] && line.strip.empty?)
            puts "#{num.to_s.rjust(6)}\t#{line}"
            num += 1
          else
            puts line
          end
        end
      end
    end

    Kat.new(ARGV).call

    $ kat -n file


## Credit

A substantial portion of this code is extracted directly from [Thor](https://github.com/wycats/thor)
by Yehuda Katz, José Valim, and more.
