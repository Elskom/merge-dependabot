#!/usr/bin/env ruby

require "json"
require "octokit"

json = File.read(ENV.fetch("GITHUB_EVENT_PATH"))
event = JSON.parse(json)
github = Octokit::Client.new(access_token: ENV["GITHUB_TOKEN"])

if !ENV["GITHUB_TOKEN"]
  puts "Missing GITHUB_TOKEN"
  exit(1)
end

repo = event["repository"]["full_name"]
user = event["user"]

if ENV.fetch("GITHUB_EVENT_NAME") == "pull_request"
  pr_number = event["number"]
else
  pulls = github.pull_requests(repo, state: "open")
  push_head = event["after"]
  pr = pulls.find { |pr| pr["head"]["sha"] == push_head }

  if !pr
    puts "Couldn't find an open pull request for branch with head at #{push_head}."
    exit(1)
  end

  pr_number = pr["number"]
end

coms = github.issue_comments(repo, pr_number)
duplicate = coms.find { |c| c["body"] == "@dependabot merge" }

if user != "app/dependabot" # check for if the user is not dependabot.
  puts "The user is not dependabot. Skipping auto merge."
  exit(0)
end

if duplicate
  puts "The PR already contains this message"
  exit(0)
end

github.add_comment(repo, pr_number, "@dependabot merge")
