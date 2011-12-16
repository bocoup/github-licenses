require "rubygems"
require "github_api"

@github = Github.new


@github.git_data.tree 'peter-murach', 'github', 'c18647b75d72f19c1e0cc8af031e5d833b7f12ea', :recursive => true do |file|
  if /README/.match file.path
    puts file.path
  end
end
