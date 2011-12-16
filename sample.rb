require "rubygems"
require "github_api"
require "octokit"

Octokit.search_repos("game").each do |result|
  puts "Owner: #{result.owner}, Project: #{result.url}"
end


