require "rubygems"
require "github_api"
require "json"
require "base64"
require "octokit"

@data = Array.new
@github = Github.new
@filenamePatterns = {
	:license => /licen[cs]e|mit/i,
	:readme => /readme/i
}
@outfile = File.open("out.csv", "w")

def getMaster( author, repo )
	@githubb = Github.new
	@repo = @githubb.get('/repos/' + author + '/' + repo).to_hash
	@master_branch = @repo["master_branch"]
	@githubb.get('/repos/' + author + '/' + repo + '/commits', { :sha => @master_branch } )[0]
end

def inspectRepo( author, name )
	puts "Mike", @masterbranch = getMaster( author, name )

	@found = false
	@outfile.syswrite author + "," + name + ","
	@tree = @github.git_data.tree author, name, @masterbranch["sha"] do |file|
	  if @filenamePatterns[:license].match file.path
	  
	    @gh = Github.new
	    
	    begin
	  	  @blog = @gh.get('/repos/' +author+ '/'  +name+ '/git/blobs/' + file.sha)
	  	rescue
	  	  next
	  	end
	  	@license_file_name = author + '_' + name + '_' + file.path.gsub('/', '__')
		@licensefile = File.open( 'licenses/' + @license_file_name , "w")
		@licensefile.syswrite( Base64.decode64(@blog.content) )
		puts "\n\n\n", file, "\n\n\n", "PATH:" + file.path, "\n\n\n"
		@outfile.syswrite "https://raw.github.com/" + author + "/" + name + "/" +@masterbranch["sha"]+ "/" + file.path + "," + @license_file_name + ",,\n"
		@found = true

	  if @filenamePatterns[:readme].match file.path
	  
	    @gh = Github.new
	    begin
	  	  @blog = @gh.get('/repos/' +author+ '/'  +name+ '/git/blobs/' + file.sha)
	  	rescue
		  next
		end
	  	@readme_file_name = author + '_' + name + '_' + file.path.gsub('/', '__')
		@licensefile = File.open( 'readmes/' + @readme_file_name , "w")
		@licensefile.syswrite( Base64.decode64(@blog.content) )
		puts "\n\n\n", file, "\n\n\n", "PATH:" + file.path, "\n\n\n"
		@outfile.syswrite "https://raw.github.com/" + author + "/" + name + "/" +@masterbranch["sha"]+ "/" + file.path + ",,," + @readme_file_name + "\n"
		@found = true
      end

	end
	
	if !@found
	  @outfile.syswrite author + "," + name + ",,,,\n"
	end
end

@outfile.syswrite "Author,Repo Name,License File URL,License File Name,Readme File URL,Readme File Name\n"

Octokit.search_repos('game',{:start_page => 2}).each do |result|
  inspectRepo( result.owner, result.name )
end
#inspectRepo('annasob', 'popcorn-js' )


