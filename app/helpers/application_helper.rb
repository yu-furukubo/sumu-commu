module ApplicationHelper
  def check_member_created(obj)
    if obj.member_id == 0
      obj.residence.admin.name + "(管理者)"
    elsif Member.find_by(id: obj.member_id).nil?
      "(退会済み会員)"
    else
      obj.member.name
    end
  end

end
