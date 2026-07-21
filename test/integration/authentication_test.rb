require "test_helper"

class AuthenticationTest < ActionDispatch::IntegrationTest
  test "registers an owner and workspace" do
    assert_difference [ "User.count", "Account.count", "Membership.count" ], 1 do
      post registration_path, params: {
        account_name: "Acme Inc",
        user: { name: "Ada Lovelace", email_address: "ada@example.com", password: "password123", password_confirmation: "password123" }
      }
    end

    assert_redirected_to dashboard_path
    assert User.last.memberships.last.owner?
  end

  test "rejects invalid credentials" do
    post session_path, params: { email_address: "missing@example.com", password: "wrong" }
    assert_redirected_to new_session_path
  end
end
