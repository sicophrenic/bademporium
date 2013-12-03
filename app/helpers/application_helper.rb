#-*- coding: utf-8 -*-#
module ApplicationHelper
  def flash_msg(type)
    case type
      when :alert
        "alert-danger"
      when :error
        "alert-danger"
      when :notice
        "alert-info"
      when :success
        "alert-success"
      else
        type.to_s
    end
  end
end