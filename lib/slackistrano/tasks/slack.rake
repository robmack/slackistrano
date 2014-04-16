namespace :slack do
  namespace :deploy do

    task :starting do
      if fetch(:slack_run_starting)
        run_locally do
          Slackistrano.post(
            team: fetch(:slack_team),
            token: fetch(:slack_token),
            payload: {
              channel: fetch(:slack_channel),
              username: fetch(:slack_username),
              icon_emoji: fetch(:slack_icon_emoji),
              text: fetch(:slack_msg_starting)
            }
          )
        end
      end
    end

    task :finished do
      if fetch(:slack_run_finished)
        run_locally do
          Slackistrano.post(
            team: fetch(:slack_team),
            token: fetch(:slack_token),
            payload: {
              channel: fetch(:slack_channel),
              username: fetch(:slack_username),
              icon_emoji: fetch(:slack_icon_emoji),
              text: fetch(:slack_msg_finished)
            }
          )
        end
      end
    end
  end
end

before 'deploy:starting', 'slack:deploy:starting'
after 'deploy:finished', 'slack:deploy:finished'

namespace :load do
  task :defaults do
    set :slack_team,         ->{ nil } # If URL is 'team.slack.com', value is 'team'. Required.
    set :slack_token,        ->{ nil } # Token from Incoming WebHooks. Required.
    set :slack_channel,      ->{ nil } # Channel to post to. Optional. Defaults to WebHook setting.
    set :slack_icon_url,     ->{ 'http://gravatar.com/avatar/885e1c523b7975c4003de162d8ee8fee?r=g&s=40' }
    set :slack_icon_emoji,   ->{ ':shipit:' }
    set :slack_username,     ->{ 'Slackistrano' }
    set :slack_run_starting, ->{ true } # Set to false to disable starting message.
    set :slack_run_finished, ->{ true } # Set to false to disable finished message.
    set :slack_msg_starting, ->{ "#{ENV['USER'] || ENV['USERNAME']} has started deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :rails_env, 'production'}." }
    set :slack_msg_finished, ->{ "#{ENV['USER'] || ENV['USERNAME']} has finished deploying branch #{fetch :branch} of #{fetch :application} to #{fetch :rails_env, 'production'}." }
  end
end
