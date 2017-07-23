# Process command-line arguments
class Arguments

    def initialize argv
        @argv = argv
        @known_options = [
            '--errors-only',
            '--silent',
            '--debug',
            '--help',
            '-h',
            '--version',
            '-v'
        ]
    end

    def scope
        scope = @argv[0]
        return nil if !scope || scope.start_with?('-')
        scope
    end

    def hasAny? *keys
        keys.each do |key|
            @argv.each do |argument|
                return true if argument.start_with? key
            end
        end
        false
    end

    def unknown_options
        args = @argv.clone
        args.shift # Remove scope
        args.reject! do |arg|
            @known_options.any? { |ko| arg.start_with? ko }
        end
        args
    end
end
