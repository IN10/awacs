require_relative 'checks/Check.rb'

class Results

    def initialize
        @pages = {}
    end

    def all
        @pages
    end

    def addPage path
        @pages[path] ||= []
    end

    def hasErrors?
        entries = @pages.values.flatten(2)
        errors = entries.select { |entry| entry.type == Check::ERROR }
        errors.count > 0
    end
end
