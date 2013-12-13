#-*- coding: utf-8 -*-#
module BlackjackHelper
  def include_firebase
    load_firebase
    link_firebase
  end

  def load_firebase
    javascript_tag "<script src=\"https://cdn.firebase.com/v0/firebase.js\"></script>"
  end

  def link_firebase
    javascript_tag "
      var dataRef = new Firebase(\"https://bademporium.firebaseio.com\");
    "
  end
end
