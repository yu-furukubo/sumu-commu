module ApplicationHelper
  require "rqrcode"
  require "rqrcode_png"
  require "chunky_png"

  def qrcode(url, size)
    if Rails.env.development?
      qrcode = RQRCode::QRCode.new("https://1fa9da296ed8419486c19f2bf08c634c.vfs.cloud9.ap-northeast-1.amazonaws.com/#{url}")
    elsif Rails.env.production?
      qrcode = RQRCode::QRCode.new("http://54.95.44.107/#{url}")
    end
    svg = qrcode.as_svg(
      color: "000",
      shape_rendering: "crispEdges",
      module_size: size,
      standalone: true,
      use_path: true
    ).html_safe
  end

  def make_url(url)
    if Rails.env.development?
      "https://1fa9da296ed8419486c19f2bf08c634c.vfs.cloud9.ap-northeast-1.amazonaws.com/#{url}"
    elsif Rails.env.production?
      "http://54.95.44.107/#{url}"
    end
  end

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
