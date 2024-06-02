require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should create user with unique email' do
    email = 'newuser@example.com'
    assert_difference('User.count') do
      post users_url, params: { user: { email: } }, as: :json
    end

    json_response = JSON.parse(@response.body)
    assert_response :created
    assert_equal json_response['email'], email
  end

  test "should not create user if email already exists" do
    email = 'newuser@example.com'
    User.create(email:)

    post users_url, params: { user: { email: 'newuser@example.com' } }, as: :json
    json_response = JSON.parse(@response.body)
    assert_equal json_response, {"email"=>["has already been taken"]}
    assert_response :unprocessable_entity
  end

  test "should return empty array when no users exist" do
    get users_url, as: :json
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response, []
  end

  test "should return empty object if no users are present" do
    user = User.create(email: 'newuser@example.com')
    get users_url, as: :json
    assert_response :success

    json_response = JSON.parse(@response.body)
    assert_equal json_response, [user.as_json]
  end
end
