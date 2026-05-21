require "pusher"

Pusher.app_id =
  Rails.application.credentials
       .pusher[:app_id]

Pusher.key =
  Rails.application.credentials
       .pusher[:key]

Pusher.secret =
  Rails.application.credentials
       .pusher[:secret]

Pusher.cluster =
  Rails.application.credentials
       .pusher[:cluster]

Pusher.encrypted = true
