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
            '-v',
            '--username',
            '--password'
        ]
    end

    def scope
        scope = @argv[0]
        return nil if !scope || scope.start_with?('-')
        scope
    end

    def username
        get '--username'
    end

    def password
        get '--password'
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

    def get key
        candidates = @argv.select {|arg| arg.start_with? key}
        return nil if candidates.count == 0
        candidate = candidates.first
        parts = candidate.split('=')
        return nil if parts.count < 2
        parts.last
    end
end
