require "rubygems"
require "github_api"
require "json"
require "base64"
require "octokit"

@data = Array.new
@github = Github.new
@licenseFilePattern = /licen[cs]e|mit/i
@outfile = File.open("out.txt", "w")

def getMaster( author, repo )
	@githubb = Github.new
	@repo = @githubb.get('/repos/' + author + '/' + repo).to_hash
	@master_branch = @repo["master_branch"]
	@githubb.get('/repos/' + author + '/' + repo + '/commits', { :sha => @master_branch } )[0]
end


def inspectRepo( author, name )
	puts "Mike", @masterbranch = getMaster( author, name )
	#puts branch.commit.methods.join(", ")
	@tree = @github.git_data.tree author, name, @masterbranch["sha"], :recursive => true do |file|
	  if @licenseFilePattern.match file.path
	  
	    @gh = Github.new
	  	@blog = @gh.get('/repos/' +author+ '/'  +name+ '/git/blobs/' + file.sha)
		@outfile.syswrite "\t" + file.path + "\n"
		@licensefile = File.open( 'licenses/' + author + '_' + name + '_' + file.path.gsub('/', '__') , "w")
		@licensefile.syswrite( Base64.decode64(@blog.content) )
	  end
	end
end

Octokit.search_repos('game',{:start_page => 2}).each do |result|
  inspectRepo( result.owner, result.name )
end
inspectRepo('annasob', 'popcorn-js' )


