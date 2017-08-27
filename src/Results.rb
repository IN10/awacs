require_relative 'checks/Check.rb'

# Results of the analysis
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
        errors = entries.select { |entry| entry[:type] == Check::ERROR }
        errors.count > 0
    end

    def hasWarnings?
        entries = @pages.values.flatten(2)
        warnings = entries.select { |entry| entry[:type] == Check::WARNING }
        warnings.count > 0
    end
end
