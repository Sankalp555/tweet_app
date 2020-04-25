json.(user, :id, :email, :first_name, :last_name, :gender, :phone_number)
json.organization user.organization_name
json.token user.generate_jwt