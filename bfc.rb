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

# Output variable scoped to program
pages = []

# Define checks to run
checks = [PrintsErrors.new]

# Create a temporary directory for us to use
Dir.mktmpdir do |directory|
    # Download the website with wget
    `(cd #{directory}; wget --quiet --recursive --no-parent --follow-tags=a --random-wait -erobots=off #{scope})`

    # Iterate over all downloaded files
    files = Dir.glob("#{directory}/**/*").select {|f| !File.directory? f}
    pages = files.map do |path|
        # Read the file, feed it to all checkers
        contents = File.open(path, "r").read
        url = path.sub directory+"/", ""
        [url, checks.map { |checker| checker.check(contents) }.flatten(1)]
    end
end

# Remove succesful results when not required
pages.select! { |page| page[1].count > 1 } if errorsOnly

# Format results
table = TTY::Table.new ['Path', 'Results'], Formatter.new.format(pages)
puts "Results"
puts table.render :ascii, multiline: true
