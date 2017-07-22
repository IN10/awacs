class Debugger

    def initialize enabled
        @enabled = enabled
    end

    def debug message
        return unless @enabled
        puts "debug: #{message}\n"
    end
end

