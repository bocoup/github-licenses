require "rubygems"
require "github_api"

@github = Github.new
@licenseFilePattern = /licen[cs]e/
@outfile = File.open("out.txt", "w")

def processTree( tree )
	puts "Tree", tree, "\n\n"
=begin	tree.each { |files|
		files.each { |file|
		puts file, file.class, "\n\n"
		if file.class != "Array"# && file.type == "blob"
			if @licenseFilePattern.match file.path
				@outfile.syswrite "Has License file!\n"
			end
		end
		}
	}
=end
end


@githubb = Github.new
@githubb.repos.get_repo('annasob', 'popcorn-js')
puts @githubb
exit

#annasob/popcorn-js
@repo = Github::Repos.new :user => 'annasob', :repo => 'popcorn-js'
puts @repo.inspect
puts @repo.methods.sort.join(", ")
puts @repo.description
exit
#puts @repos.methods.sort
@repo.branches do |branch|
  @outfile.syswrite "Branch '" + branch.name + "'\n"
  @outfile.syswrite "\tLatest commit: " + branch.commit.sha + "\n"
  #puts branch.commit.methods.join(", ")
  @tree = @github.git_data.tree 'annasob', 'popcorn-js', branch.commit.sha, :recursive => true do |file|
    #processTree( @tree )
    @outfile.syswrite "\t" + file.path + "\n"
  end
end



=begin
def scanRepo( author, reponame, tree )
  findings = {}
  @github.git_data.tree author, reponame, tree, :recursive => true do |file|
    if @licenseFilePattern.match file.path
      puts file.path
    end
    if /README/.match file.path
      puts file.path
    end
  end
end

scanRepo( 'peter-murach', 'github', 'c18647b75d72f19c1e0cc8af031e5d833b7f12ea' )
scanRepo( 'jquery', 'jquery', '' );
=end

