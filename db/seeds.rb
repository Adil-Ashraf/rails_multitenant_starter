# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
user = User.find_or_create_by!(email_address: "owner@example.com") do |record|
  record.name = "Demo Owner"
  record.password = "password123"
  record.password_confirmation = "password123"
end
account = Account.find_or_create_by!(slug: "demo") { |record| record.name = "Demo Workspace" }
Membership.find_or_create_by!(user:, account:) { |record| record.role = :owner }
