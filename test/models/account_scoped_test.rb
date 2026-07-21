require "test_helper"

class AccountScopedTest < ActiveSupport::TestCase
  test "raises when tenant context is absent" do
    model = Class.new(ApplicationRecord) do
      self.table_name = "accounts"
      include AccountScoped
    end

    Current.reset
    assert_raises(RuntimeError) { model.to_a }
  end
end
