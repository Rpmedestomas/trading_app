admin = User.new(email:"admin@example.com", password:"123456", password_confirmation:"123456", admin:true, user_status: 'Approved' )

admin.skip_confirmation!
admin.save

user = User.new(email:"user@example.com", password:"123456", password_confirmation:"123456", admin:false, user_status: 'Approved')

user.skip_confirmation!
user.save
