class Check
    # Slow checkers can be marked as such and will be skipped when the program
    # is run with the --fast option.
    attr_reader :slow

    SUCCESS = 0
    WARNING = 1
    ERROR = 2

    def initialize arguments
        @arguments = arguments
        @slow = false
    end
end
