require "rubygems"
require "github_api"
require "json"
require "base64"
require "octokit"
require 'faraday'

@data = Array.new
@github = Github.new
@filenamePatterns = {
  :license => /licen[cs]e|mit/i,
  :readme => /readme/i
}
@files = {
  :err => File.open("errors.txt", "w"),
  :out => File.open("out.csv", "w")
}

def printError( msg, author, repo )
	@files[:err].syswrite '--- ' + author + ' / ' + repo + ' ---' + "\n" + msg + "\n"
end

def getMaster( author, repo )
  @repo = @github.get('/repos/' + author + '/' + repo).to_hash
  @master_branch = @repo["master_branch"]
  @github.get('/repos/' + author + '/' + repo + '/commits', { :sha => @master_branch } )[0]
end

def inspectRepo( author, name )

  @masterbranch = getMaster( author, name )
  @found = false
  @files[:out].syswrite author + "," + name + ","
  @tree = @github.git_data.tree author, name, @masterbranch["sha"] do |file|
    if @filenamePatterns[:license].match file.path

      requestURI = '/repos/' +author+ '/'  +name+ '/git/blobs/' + file.sha

      begin
        @blog = @github.get(requestURI)
      rescue
      	printError('Error retrieving file blob. URI: ' + requestURI, author, name )
        next
      end
      @license_file_name = author + '_' + name + '_' + file.path.gsub('/', '__')
      @licensefile = File.open( 'licenses/' + @license_file_name , "w")
      @licensefile.syswrite( Base64.decode64(@blog.content) )
      @files[:out].syswrite "https://raw.github.com/" + author + "/" + name + "/" +@masterbranch["sha"]+ "/" + file.path + "," + @license_file_name + ",,\n"
      @found = true

    elsif @filenamePatterns[:readme].match file.path

      requestURI = '/repos/' +author+ '/'  +name+ '/git/blobs/' + file.sha
      begin
        @blog = @github.get(requestURI)
      rescue
        printError('Error retrieving file blob. URI: ' + requestURI, author, name )
        next
      end
      @readme_file_name = author + '_' + name + '_' + file.path.gsub('/', '__')
      @licensefile = File.open( 'readmes/' + @readme_file_name , "w")
      @licensefile.syswrite( Base64.decode64(@blog.content) )
      @files[:out].syswrite "https://raw.github.com/" + author + "/" + name + "/" +@masterbranch["sha"]+ "/" + file.path + ",,," + @readme_file_name + "\n"
      @found = true
    end

    if !@found
      @files[:out].syswrite author + "," + name + ",,,,\n"
    end
  end
end

@files[:out].syswrite "Author,Repo Name,License File URL,License File Name,Readme File URL,Readme File Name\n"

Octokit.search_repos('game',{:start_page => 2}).each do |result|
  inspectRepo( result.owner, result.name )
end
#inspectRepo('annasob', 'popcorn-js' )
