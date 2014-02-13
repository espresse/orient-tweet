FactoryGirl.define do
  factory :user do
    username "John"
    email  "john@doe.pl"
  end

  factory :valid_user, class: User do
    username "John"
    email  "john@doe.pl"
    password "password123"
    password_confirmation "password123"
  end
end