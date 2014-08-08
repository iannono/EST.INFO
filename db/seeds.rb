AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') if AdminUser.all.count == 0
