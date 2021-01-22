FROM ruby:2.7-alpine

LABEL "com.github.actions.name"="Merge Dependabot"
LABEL "com.github.actions.description"="Leaves a comment on an open PR from dependabot when build passes to merge."
LABEL "com.github.actions.repository"="https://github.com/Elskom/merge-dependabot"
LABEL "com.github.actions.maintainer"="AraHaan <seandhunt_7@yahoo.com>"
LABEL "com.github.actions.icon"="at-sign"
LABEL "com.github.actions.color"="purple"

RUN gem install octokit

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
