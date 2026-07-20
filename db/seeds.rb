# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

admin_email = ENV["ADMIN_EMAIL"]
admin_password = ENV["ADMIN_PASSWORD"]

if Rails.env.production?
  raise "ADMIN_EMAILを設定してください" if admin_email.blank?
  raise "ADMIN_PASSWORDを設定してください" if admin_password.blank?
else
  admin_email ||= "admin@example.com"
  admin_password ||= "password"
end

admin = Admin.find_or_initialize_by(email: admin_email)

if admin.new_record?
  admin.password = admin_password
  admin.password_confirmation = admin_password
  admin.save!

  puts "初期管理者を作成しました: #{admin.email}"
else
  puts "初期管理者は作成済みです: #{admin.email}"
end
