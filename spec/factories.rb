FactoryGirl.define do
  factory :user do
    name "sally"
    email "sally@email.com"
    password "foobar"
    password_confirmation "foobar"
  end
end
