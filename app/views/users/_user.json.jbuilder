json.extract! user, :id, :email, :first_name, :last_name, :gender, :member, :created_at, :updated_at
json.url user_url(user, format: :json)
