user ||= @user

json.name        user.name
json.email       user.email
json.id          user.id
json.number      user.number
json.auth_token  user.authentication_token
json.customer_id user.customer_id
