class AdminUser
  attr_accessor :admin_id, :display_name, :mojang, :steam64, :permissions, :email

  def initialize(admin_id, display_name, mojang, steam64, permissions, email)
    @admin_id = admin_id
    @display_name = display_name
    @mojang = mojang
    @steam64 = steam64
    @permissions = permissions
    @email = email
  end
end
