# Process command-line arguments
class Arguments

    def initialize argv
        @argv = argv
        @known_options = [
            '-e', '--errors',
            '-w', '--warnings',
            '-h', '--help',
            '-v', '--version',
            '-f', '--fast',
            '--username',
            '--password',
            '--folder',
            '--output',
        ]
    end

    def scope
        scope = @argv[0]
        return nil if !scope || scope.start_with?('-')
        scope
    end

    def username
        get_value '--username'
    end

    def password
        get_value '--password'
    end

    def folder
        get_value '--folder'
    end

    def output
        get_value '--output'
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

    private

    def get_value key
        candidates = @argv.select {|arg| arg.start_with? key}
        return nil if candidates.count == 0
        candidate = candidates.first
        parts = candidate.split('=')
        return nil if parts.count < 2
        parts.last
    end
end
