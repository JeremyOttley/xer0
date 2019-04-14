require 'irb/completion'
ARGV.concat [ "--readline" ]

IRB.conf[:PROMPT_MODE] = :SIMPLE

IRB.conf[:EVAL_HISTORY] = 1000

require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 100

#%w{ rubygems yaml what_methods wirble hpricot }.each { |lib| require lib }

# Check for presence of required gems. 
# If not present, install the gems
%w[wirble awesome_print fileutils yaml json csv open-uri].each do |gem|
  begin
    require gem
  rescue LoadError
    `gem install #{gem}`
     Gem.clear_paths
  end
end

AwesomePrint.irb!
Wirble.init
Wirble.colorize

include FileUtils

def time(times=1)
  require "benchmark"
  ret = nil
  Benchmark.bm { |x| x.report { times.times { ret = yield } } }
  ret
end
alias bench time

def howl *args
  flattened_args = args.map {|arg| "\"#{arg.to_s}\""}.join ' '
  `howl #{flattened_args}`
  nil
end

def aorta( obj )
  tempfile = File.join('/tmp',"yobj_#{ Time.now.to_i }")
  File.open( tempfile, 'w' ) { |f| f << obj.to_yaml }
  system( "#{ ENV['EDITOR'] || 'vi' } #{ tempfile }" )
  return obj unless File.exists?( tempfile )
  content = YAML::load( File.open( tempfile ) )
  File.delete( tempfile )
  content
end

# Print Documentation
	# Example: String.ri :sub
	# Source: http://github.com/ryanb/dotfiles/blob/145906d11810c691dbb1a47481d790e3ad186dcb/irbrc
	def ri(method = nil)
	  unless method && method =~ /^[A-Z]/ # if class isn't specified
	    klass = self.kind_of?(Class) ? name : self.class.name
	    method = [klass, method].compact.join('#')
	  end
	  puts `ri '#{method}'`
	end

class Array
  def self.toy(n=10, &block)
    block_given? ? Array.new(n,&block) : Array.new(n) {|i| i+1}
  end
end

class Hash
  def self.toy(n=10)
    Hash[Array.toy(n).zip(Array.toy(n){|c| (96+(c+1)).chr})]
  end
end
