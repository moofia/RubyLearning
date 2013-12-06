#!/usr/bin/env ruby

# ATLAS: Always start with the shebang http://en.wikipedia.org/wiki/Shebang_(Unix) , in this case as i am a Mac user i start slightly 
#        differently with env which ensures the script works across platforms.

# script      : scrape.rb
# created by  : Jacques Atlas <atlas@wire.org.za>
# created at  : 2013-12-05 17:18:01
# customer    : Darko Mark
# description : This script is part of a series in learning Ruby by doing. A url will be given as an
#               argument, an http connection will be create to get the url saving the contents in a file. 

# ATLAS: Always say why you are writing this script and what you aim to do, it will seem like a waste or almsot redundent. Best practices
#        will save you hours in the future. You can include your license here if you wish.

require 'getopt/long'
require 'net/http'

# ATLAS: The name of the script is being used in many places so we store it in a variable.
#        We need to create an instance variable as we require the variable in our methods also. In this case its not something we
#        want to pass to our methods.
@script = File.basename $0

# ATLAS: I created the help to be a method as its used in twice already.
def help
  puts "usage: #{@script} --site [URL]"
  puts
  puts "       --site    the site name to save the site"
end

# ATLAS: We are using rescue here only on the section we want (dont rescue more than you are after, eg never rescue the whole script). Our 
#        goal is to print the help (usage) and display the wrong command line option exiting the script with an error.
#        For now i removed the shortened arguments, we not after less - we after reability.

begin
  opt = Getopt::Long.getopts(
      ["--help",   Getopt::BOOLEAN],
      ["--site",   Getopt::REQUIRED]
  )
rescue Getopt::Long::Error => error
    puts "#{@script} error #{error.message}"  
    puts
    help
    exit 2 
end

# ATLAS: We want to force the user in the correct direction when they run the script without arguments
help if opt["help"]
help if opt.count == 0

# ATLAS: We do some basic regex on the site name, for now this is basic. We can expand later as we refactor. 
if opt["site"] =~ /\w+\.\w+/
  site_name = opt["site"]
  # ATLAS: Once again we are using rescue here as we must catch the error messages from net/http. Test with bad websites.
  #        You will learn when to use rescue, its not something to go wild with. 
  begin
    # ATLAS: We wanted the cli argument to be that of a of a website so we must build the URI syntax by adding in the protocol
    uri = URI("http://#{site_name}/index.html")
    html = Net::HTTP.get(uri)
  rescue => error
    puts "#{@script} error: #{error}"
    exit 2
  end
  # ATLAS: Dump the html, we can now continue with the task of saving this to a file.
  puts html
else 
  puts "#{@script} error: a site name of \"#{opt["site"]}\" is not valid"
  exit 2
end
