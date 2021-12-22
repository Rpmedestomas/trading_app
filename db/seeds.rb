admin = User.new(email:"arwiepogi@gmail.com", password:"123456", password_confirmation:"123456", admin:true, user_status: 'Approved' )

admin.skip_confirmation!
admin.save

