require 'rubygems'
require 'tty-table'
require 'tty-spinner'
require 'tmpdir'

require './Formatter.rb'
require './checks/PrintsErrors.rb'

# Parse command line arguments
scope = ARGV[0]
errorsOnly = ARGV.include? '--errors-only'

# Show usage instructions when no start url is given
unless scope
    puts "Usage: ruby bfc.rb [scope]"
    puts "Scope should be a website directory, e.g. http://in10.nl/nieuws"
    exit 1
end

# Show spinner
spinner = TTY::Spinner.new "[:spinner] :operation"
spinner.update operation: 'Initializing'
spinner.auto_spin

# Output variable scoped to program
pages = []

# Define checks to run
checks = [PrintsErrors.new]

# Create a temporary directory for us to use
spinner.update operation: 'Creating temporary directory'
Dir.mktmpdir do |directory|
    spinner.update operation: 'Downloading all pages of the website'
    # Download the website with wget
    `(cd #{directory}; wget --quiet --recursive --no-parent --follow-tags=a --random-wait -erobots=off #{scope})`

    # Iterate over all downloaded files
    spinner.update operation: 'Checking for problems'
    files = Dir.glob("#{directory}/**/*").select {|f| !File.directory? f}
    pages = files.map do |path|
        # Read the file, feed it to all checkers
        contents = File.open(path, "r").read
        url = path.sub directory+"/", ""
        {url: url, results: checks.map { |checker| checker.check(contents) }.flatten(1)}
    end
end

# Remove succesful results when not required
if errorsOnly
    spinner.update operation: 'Filtering results'
    pages.select! { |page| page[:results].count > 1 }
end

spinner.update(operation: 'All done')
spinner.success

# Format results
table = TTY::Table.new ['Path', 'Results'], Formatter.new.format(pages)
puts "\nResults"
puts table.render :ascii, multiline: true
