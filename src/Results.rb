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
        entries = @pages.values.flatten(1)
        errors = entries.select { |entry| entry[:type] == Check::ERROR }
        errors.count > 0
    end

    def hasWarnings?
        entries = @pages.values.flatten(1)
        warnings = entries.select { |entry| entry[:type] == Check::WARNING }
        warnings.count > 0
    end

    # Remove entries that have no errors or warnings
    def removeSuccesses!
        @pages.reject! { |page, entries| entries.length == 0 }
    end

    # Remove entries that have only errors
    def removeErrors!
        @pages.reject! { |page, entries| entries.any? { |entry| entry[:type] == Check::ERROR } }
    end

    # Remove entries that have only warnings
    def removeWarnings!
        @pages.reject! { |page, entries| entries.any? { |entry| entry[:type] == Check::WARNING } }
    end
end
